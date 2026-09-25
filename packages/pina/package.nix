{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.21.0";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-WwuWk6T0OfV/0auSuMAdI2D8ZzePeYhWvlW6ovdXl+Y=";
    "x86_64-apple-darwin" = "sha256-qA1GlQZpcJMjfkeURrf8DW2Y9Q2csTvvvOyyD0U7TIc=";
    "x86_64-unknown-linux-gnu" = "sha256-tx9VHZ29kieT75tkKO2QiGvZQ3fzZ8AIS3WrJ//WL+I=";
    "aarch64-unknown-linux-gnu" = "sha256-tJrgBylMJFnOgV+OwIlcfQzjuO/S31ar3WXET8e4rIQ=";
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
