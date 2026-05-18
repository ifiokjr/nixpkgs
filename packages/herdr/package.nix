{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.5.10";

  platformSuffix =
    {
      "aarch64-darwin" = "macos-aarch64";
      "x86_64-darwin" = "macos-x86_64";
      "aarch64-linux" = "linux-aarch64";
      "x86_64-linux" = "linux-x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "macos-aarch64" = "sha256-hKp/OMg1tOtao4wpZggTAjzyMXjkZUHEucJgcS/lLVE=";
    "macos-x86_64" = "sha256-5yMqu9BWiHuv4Pa4Hlj1njPK/XrGCeO8w1S44A77Bjc=";
    "linux-aarch64" = "sha256-ly1ips1U0BYtLegNuY2uQVt3L1WCL09fb4wy0BZLKbk=";
    "linux-x86_64" = "sha256-9FwU+UnYW0dOcpd6AJ2B2lL7pORuKgJEjb+lk3Bl/Uw=";
  };
in
stdenv.mkDerivation {
  pname = "herdr";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/herdr-${platformSuffix}";
    hash = hashes.${platformSuffix} or lib.fakeHash;
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/herdr
    chmod +x $out/bin/herdr

    runHook postInstall
  '';

  meta = {
    description = "Terminal agent multiplexer – tmux for coding agents";
    homepage = "https://github.com/ogulcancelik/herdr";
    license = lib.licenses.agpl3Only;
    mainProgram = "herdr";
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
    ];
  };
}
