{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dbus,
}:

let
  version = "0.5.0";

  # Rust target triple for the host platform, e.g. aarch64-apple-darwin.
  platformSuffix = stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-50DbXJLO/0FRhCBc+dAfo4vmu2ypl98shdLpLkptzCc=";
    "aarch64-unknown-linux-gnu" = "sha256-ylJmRyR9sbQpDhREJAfoD1X7YExc5lyzzG8hyb898dE=";
    "x86_64-unknown-linux-gnu" = "sha256-MQLo9sy/YbnocK45a2Bjqc2W2Vrx02zC1/w5AXsSs7g=";
  };
in
stdenv.mkDerivation {
  pname = "monosecret";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/monosecret/${version}/monosecret-${platformSuffix}.tar.gz";
    hash = hashes.${platformSuffix} or (throw "monosecret: no prebuilt for ${platformSuffix}");
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    # The keyring crate talks to the system secret service over dbus.
    dbus
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    tar xzf $src -C $out/bin/
    chmod +x $out/bin/monosecret

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo "Checking monosecret version..."
    $out/bin/monosecret --version

    runHook postInstallCheck
  '';

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://ifiokjr.github.io/monosecret";
    license = lib.licenses.asl20;
    mainProgram = "monosecret";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "dev-tool"
      "rust"
      "secrets"
    ];
  };
}
