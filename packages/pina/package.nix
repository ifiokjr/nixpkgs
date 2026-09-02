{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.12.2";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-vK2tpWfYpwfT4IlExkf963GnuuBOz/klpZ1wJ/v9Lsk=";
    "x86_64-apple-darwin" = "sha256-bk3dlSHzljCapaTIX/aeKNfseyQkOXjgERqOOtov/NA=";
    "x86_64-unknown-linux-gnu" = "sha256-q59XN3p/3J7EsOGqgdlqgAegWLoYDiXLkTB00Yhw1gY=";
    "aarch64-unknown-linux-gnu" = "sha256-U5Z3f8Iz4fT9ocp+8u3pKtr2Cjgu+uU/ku+e+wScbjw=";
  };
in
stdenv.mkDerivation {
  pname = "pina";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/pina/${version}/pina-${platformSuffix}.tar.gz";
    hash = hashes.${platformSuffix} or (throw "No prebuilt for platform: ${platformSuffix}");
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    tar xzf $src -C $out/bin/
    chmod +x $out/bin/pina

    runHook postInstall
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
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "dev-tool"
      "solana"
    ];
  };
}
