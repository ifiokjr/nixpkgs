{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.17.0";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-y1r1qbCRZxUZ8cuz70rvJ2JNBBUa+lk7q3EohM/1cpY=";
    "x86_64-apple-darwin" = "sha256-F15GbV8ky6I9aeQflYtyb6BiCv+9jV/Mj1k+I++/GgM=";
    "x86_64-unknown-linux-gnu" = "sha256-ec88q0WMr9R6jAco2t2eCypFZH0ww4nio3G9Wj7LImw=";
    "aarch64-unknown-linux-gnu" = "sha256-mgOoRG/vqDlTcmDOLKB7rezh8vGL6/HHf41w3hzagAU=";
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
