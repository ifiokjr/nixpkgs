{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  autoPatchelfHook,
  symlinkJoin,
  llvmPackages_21,
  llvmPackages_22,
  zlib,
  zstd,
  variant ? "22",
}:

let
  configs = {
    "21" = rec {
      version = "0.1.6";
      feature = "upstream-gallery-21";
      llvmPackages = llvmPackages_21;
      src = fetchFromGitHub {
        owner = "blueshift-gg";
        repo = "sbpf-linker";
        rev = "4b6e888cd306b6f959d4acf7a6f0acea10c70a47";
        hash = "sha256-d8JDo21dAd85PgssTvnFTiNQ0dU/+FFwES+M6BOSBlk=";
      };
      cargoLock = {
        lockFile = ./Cargo-21.lock;
      };
      postPatch = ''
        cp ${./Cargo-21.lock} Cargo.lock
        substituteInPlace Cargo.toml \
          --replace-fail 'sbpf-assembler = "0.1.6"' 'sbpf-assembler = "=0.1.6"' \
          --replace-fail 'sbpf-common = "0.1.6"' 'sbpf-common = "=0.1.6"' \
          --replace-fail 'bpf-linker = { version = "0.10.1", default-features = false }' 'bpf-linker = { version = "=0.10.1", default-features = false }'
      '';
    };

    "22" = rec {
      version = "0.1.8";
      feature = "upstream-gallery-22";
      llvmPackages = llvmPackages_22;
      src = fetchFromGitHub {
        owner = "blueshift-gg";
        repo = "sbpf-linker";
        rev = "06b4e60fba2960f6ec6c433659a88931da934546";
        hash = "sha256-BqlgczHTV6T0ZBBke8jheQvbQqQU7ik5wloIF+1rpKU=";
      };
      cargoHash = "sha256-G+2vSiN3Y6n5BUIVu6jxQwXn+WM1cq4IJYVpxezssSU=";
      cargoPatches = [ ./Cargo.lock.patch ];
      prebuiltHashes = {
        "aarch64-apple-darwin" = "sha256-vD1n5WJV/4QSRkwpgCdexB7XGUjOEcDBk/Mj652kP7A=";
        "x86_64-apple-darwin" = lib.fakeHash;
        "aarch64-unknown-linux-gnu" = "sha256-vhB7o56elqvD+2MS7rgF18YCNIkpXhUMFSYQg2ULZpc=";
        "x86_64-unknown-linux-gnu" = "sha256-u2OrII1Hprakn7tcZC3edwhFoBLczWbP/sJmq7vaxiU=";
      };
    };
  };

  cfg = configs.${variant} or (throw "Unsupported sbpf-linker variant: ${variant}");

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  prebuiltHash = (cfg.prebuiltHashes or { }).${platformSuffix} or lib.fakeHash;
  hasPrebuilt = prebuiltHash != lib.fakeHash && !stdenv.isDarwin;

  zlibLib = zlib.static or zlib;
  zstdLib = zstd.out or zstd;

  llvmPrefix = symlinkJoin {
    name = "sbpf-linker-${variant}-llvm-prefix";
    paths = [
      cfg.llvmPackages.llvm.dev
      cfg.llvmPackages.llvm.lib
    ];
  };

  meta = {
    description = "Upstream BPF linker for SBPF V0 programs (LLVM ${variant} gallery variant)";
    homepage = "https://github.com/blueshift-gg/sbpf-linker";
    license = lib.licenses.mit;
    mainProgram = "sbpf-linker";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "linker"
      "solana"
      "bpf"
    ];
  };

  sourceBuild = rustPlatform.buildRustPackage (
    {
      pname = "sbpf-linker-${variant}";
      inherit (cfg) version src;
      cargoPatches = cfg.cargoPatches or [ ];
      postPatch = cfg.postPatch or "";
      buildNoDefaultFeatures = true;
      buildFeatures = [ cfg.feature ];
      nativeBuildInputs = [ cfg.llvmPackages.llvm ];
      buildInputs = [
        cfg.llvmPackages.libllvm
        cfg.llvmPackages.llvm.lib
        zlib
        zstd
      ];
      env = {
        LLVM_PREFIX = "${llvmPrefix}";
        ZLIB_PATH = "${zlibLib}/lib";
        LIBZSTD_PATH = "${zstdLib}/lib";
        RUSTFLAGS = "-L native=${zlibLib}/lib -L native=${zstdLib}/lib";
      }
      // lib.optionalAttrs stdenv.isDarwin {
        CXXSTDLIB_PATH = "${cfg.llvmPackages.libcxx}/lib";
      };
      doCheck = false;
      doInstallCheck = !stdenv.isDarwin;
      installCheckPhase = "test -x $out/bin/sbpf-linker";
      meta = meta // {
        sourceProvenance = [ lib.sourceTypes.fromSource ];
      };
    }
    // lib.optionalAttrs (cfg ? cargoHash) { inherit (cfg) cargoHash; }
    // lib.optionalAttrs (cfg ? cargoLock) { inherit (cfg) cargoLock; }
  );

  prebuilt = stdenv.mkDerivation {
    pname = "sbpf-linker-${variant}";
    inherit (cfg) version;
    src = fetchurl {
      url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/sbpf-linker/${cfg.version}/sbpf-linker-${platformSuffix}.tar.gz";
      hash = prebuiltHash;
    };
    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
    buildInputs = [ cfg.llvmPackages.libllvm ] ++ lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      tar xzf $src -C $out/bin/
      chmod +x $out/bin/sbpf-linker
      ${lib.optionalString stdenv.isDarwin ''
        install_name_tool -change /opt/homebrew/opt/llvm/lib/libLLVM.dylib ${cfg.llvmPackages.libllvm}/lib/libLLVM.dylib $out/bin/sbpf-linker || true
        install_name_tool -add_rpath ${cfg.llvmPackages.libllvm}/lib $out/bin/sbpf-linker || true
      ''}

      runHook postInstall
    '';
    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      test -x $out/bin/sbpf-linker
      runHook postInstallCheck
    '';
    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };
in
if hasPrebuilt then prebuilt else sourceBuild
