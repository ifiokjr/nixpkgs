{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  autoPatchelfHook,
  llvmPackages_22,
}:

let
  version = "0.1.8";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-vD1n5WJV/4QSRkwpgCdexB7XGUjOEcDBk/Mj652kP7A=";
    "x86_64-apple-darwin" = lib.fakeHash;
    "aarch64-unknown-linux-gnu" = "sha256-vhB7o56elqvD+2MS7rgF18YCNIkpXhUMFSYQg2ULZpc=";
    "x86_64-unknown-linux-gnu" = "sha256-u2OrII1Hprakn7tcZC3edwhFoBLczWbP/sJmq7vaxiU=";
  };

  prebuiltHash = hashes.${platformSuffix} or lib.fakeHash;
  hasPrebuilt = prebuiltHash != lib.fakeHash;

  meta = {
    description = "Upstream BPF linker for SBPF V0 programs";
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

  src = fetchFromGitHub {
    owner = "blueshift-gg";
    repo = "sbpf-linker";
    rev = "06b4e60fba2960f6ec6c433659a88931da934546";
    hash = "sha256-BqlgczHTV6T0ZBBke8jheQvbQqQU7ik5wloIF+1rpKU=";
  };

  sourceBuild = rustPlatform.buildRustPackage {
    pname = "sbpf-linker";
    inherit version src;
    cargoHash = "sha256-G+2vSiN3Y6n5BUIVu6jxQwXn+WM1cq4IJYVpxezssSU=";
    cargoPatches = [ ./Cargo.lock.patch ];
    buildNoDefaultFeatures = true;
    buildFeatures = [ "upstream-gallery-22" ];
    nativeBuildInputs = [ llvmPackages_22.llvm ];
    buildInputs = [ llvmPackages_22.libllvm ];
    env.LLVM_PREFIX = "${llvmPackages_22.llvm.dev}";
    doCheck = false;
    doInstallCheck = true;
    installCheckPhase = "$out/bin/sbpf-linker --help > /dev/null";
    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.fromSource ];
    };
  };

  prebuilt = stdenv.mkDerivation {
    pname = "sbpf-linker";
    inherit version;
    src = fetchurl {
      url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/sbpf-linker/${version}/sbpf-linker-${platformSuffix}.tar.gz";
      hash = prebuiltHash;
    };
    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
    buildInputs = [ llvmPackages_22.libllvm ] ++ lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      tar xzf $src -C $out/bin/
      chmod +x $out/bin/sbpf-linker

      runHook postInstall
    '';
    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      $out/bin/sbpf-linker --help > /dev/null
      runHook postInstallCheck
    '';
    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };
in
if hasPrebuilt then prebuilt else sourceBuild
