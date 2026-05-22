{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  autoPatchelfHook,
  libgit2,
  openssl,
  zlib,
}:

let
  version = "5.0.0";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-cE2uDt6/3dIgEwaYxP6EIPjBEnBSLLtH23o6Ijk2Bp0=";
    "x86_64-apple-darwin" = lib.fakeHash;
    "aarch64-unknown-linux-gnu" = "sha256-YPB68MZGpaQd6mw6lftHLrB5lHxCNRgJAlYXzaXkSpU=";
    "x86_64-unknown-linux-gnu" = "sha256-XxogF6QOWyG5Eeyy5VLaCcRxqLvmdZHwHmcQgGQTYz0=";
  };

  prebuiltHash = hashes.${platformSuffix} or lib.fakeHash;
  hasPrebuilt = prebuiltHash != lib.fakeHash;

  meta = {
    description = "Dylint tools for running Rust lints and building Dylint libraries";
    homepage = "https://github.com/trailofbits/dylint";
    license = [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    mainProgram = "cargo-dylint";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "dev-tool"
      "rust"
    ];
  };

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "dylint";
    rev = "v${version}";
    hash = "sha256-Q06arUQ0p6nWtAbpTGJdW34F9Gg6k2rXqRqkLHGe7Zs=";
  };

  sourceBuild = rustPlatform.buildRustPackage {
    pname = "dylint";
    inherit version src;
    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };
    cargoBuildFlags = [
      "--package"
      "cargo-dylint"
      "--package"
      "dylint-link"
    ];
    cargoInstallFlags = [
      "--package"
      "cargo-dylint"
      "--package"
      "dylint-link"
    ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [
      libgit2
      openssl
      zlib
    ];
    doCheck = false;
    doInstallCheck = true;
    installCheckPhase = "$out/bin/cargo-dylint --help > /dev/null";
    env = {
      LIBGIT2_NO_VENDOR = "1";
    };
    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.fromSource ];
    };
  };

  prebuilt = stdenv.mkDerivation {
    pname = "dylint";
    inherit version;
    src = fetchurl {
      url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/dylint/${version}/dylint-${platformSuffix}.tar.gz";
      hash = prebuiltHash;
    };
    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
    buildInputs = [
      libgit2
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      tar xzf $src -C $out/bin/
      chmod +x $out/bin/cargo-dylint $out/bin/dylint-link

      runHook postInstall
    '';
    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      $out/bin/cargo-dylint --help > /dev/null
      runHook postInstallCheck
    '';
    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };
in
if hasPrebuilt then prebuilt else sourceBuild
