{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  autoPatchelfHook,
  dbus,
}:

let
  version = "4.0.1";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = lib.fakeHash;
    "x86_64-apple-darwin" = lib.fakeHash;
    "aarch64-unknown-linux-gnu" = lib.fakeHash;
    "x86_64-unknown-linux-gnu" = lib.fakeHash;
  };

  prebuiltHash = hashes.${platformSuffix} or lib.fakeHash;
  hasPrebuilt = prebuiltHash != lib.fakeHash;

  meta = {
    description = "Sample code and CLI for the Rust Keyring";
    homepage = "https://github.com/open-source-cooperative/keyring-rs/wiki/Keyring";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "keyring";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "secrets"
      "rust"
    ];
  };

  sourceBuild = rustPlatform.buildRustPackage {
    pname = "keyring";
    inherit version;

    src = fetchFromGitHub {
      owner = "open-source-cooperative";
      repo = "keyring-rs";
      rev = "v${version}";
      hash = "sha256-H074FaMgRRdqRfkM8QCIN0/DifFKSSoWo1H76b0EL+w=";
    };

    cargoHash = "sha256-ePXiHOs+EhgoP6e6TSm56FxrKVq4zbkZaTmfXUnew8E=";

    nativeBuildInputs = [ pkg-config ];
    buildInputs = lib.optionals stdenv.isLinux [ dbus ];

    cargoBuildFlags = [
      "--bin"
      "keyring"
    ];

    doCheck = false;
    doInstallCheck = true;
    installCheckPhase = ''
      $out/bin/keyring --help > /dev/null
    '';

    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.fromSource ];
    };
  };

  prebuilt = stdenv.mkDerivation {
    pname = "keyring";
    inherit version;

    src = fetchurl {
      url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/keyring/${version}/keyring-${platformSuffix}.tar.gz";
      hash = prebuiltHash;
    };

    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;

    nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
    buildInputs = lib.optionals stdenv.isLinux [ dbus ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      tar xzf $src -C $out/bin/
      chmod +x $out/bin/keyring

      runHook postInstall
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      $out/bin/keyring --help > /dev/null
    '';

    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };
in
if hasPrebuilt then prebuilt else sourceBuild
