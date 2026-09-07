{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.14.0";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-uYrfSZBM5FKTwqR9dXRgE4MXu62BVSP/aMyiNqe0UdI=";
    "x86_64-apple-darwin" = "sha256-ynB6KqDhy/DH0Ag8yOIAf6TU/uhmncFY9a0Lw8BHLpU=";
    "x86_64-unknown-linux-gnu" = "sha256-bl30OvYg/pgsV5ASSvtWDW8ng/hZ/6LqlfiNdf0q41I=";
    "aarch64-unknown-linux-gnu" = "sha256-p/LY0qmIlBPBrbj4GcPg4tc4TLw4fKmUPkVpqLJz+Ko=";
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
