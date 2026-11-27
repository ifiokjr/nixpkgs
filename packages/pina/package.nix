{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.25.1";

  # Rust target triple for the host platform, e.g. aarch64-apple-darwin.
  platformSuffix = stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-A35mAbFHUM5f+qhfagEBi2nZGWciWonRwJY2fpTETAY=";
    "x86_64-apple-darwin" = "sha256-5YggFmFxS7J0qWB2QGkNLnfZ0BGZq9vHd/20Qs5c8Q0=";
    "x86_64-unknown-linux-gnu" = "sha256-8xWzsQMvvef5GCM7zh1yMc6vVNM//qHSH+VvuECmEEQ=";
    "aarch64-unknown-linux-gnu" = "sha256-4NEh4Qq7CwNosOPXlJWjKkPKotlSX7npzcuvIT/uQWo=";
  };
in
stdenv.mkDerivation {
  pname = "pina";
  inherit version;

  src = fetchurl {
    url = "https://github.com/pina-rs/pina/releases/download/v${version}/pina-${platformSuffix}-v${version}.tar.gz";
    hash = hashes.${platformSuffix} or (throw "No prebuilt for platform: ${platformSuffix}");
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # pina_lint_driver is a rustc driver plugin: rustc dlopens it at lint time
  # and provides librustc_driver from its own toolchain, so the library is
  # legitimately absent from this package's runtime closure.
  autoPatchelfIgnoreMissingDeps = [ "librustc_driver*" ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    tar xzf $src -C $out/bin/
    chmod +x $out/bin/pina

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/pina --version
    runHook postInstallCheck
  '';

  meta = {
    description = "CLI for Pina, a performant Solana smart contract framework";
    homepage = "https://pina.rs";
    license = lib.licenses.asl20;
    mainProgram = "pina";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "dev-tool"
      "solana"
    ];
  };
}
