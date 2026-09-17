{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.9.1";

  platformSuffix =
    {
      "aarch64-darwin" = "macos-aarch64";
      "x86_64-darwin" = "macos-x86_64";
      "aarch64-linux" = "linux-aarch64";
      "x86_64-linux" = "linux-x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "macos-aarch64" = "sha256-X8en5636ylb6gKqJ3LAlaTNXJo2rgoW5zi0IojE8id4=";
    "macos-x86_64" = "sha256-BTvgY5k1/lSrXvvbRmUQVOT2p1OltDFTyIvWkSvOHpQ=";
    "linux-aarch64" = "sha256-9Mz03nRfLLmjmpg+m6NwPa1Q7CpY3qgwJs6rchu9jZ4=";
    "linux-x86_64" = "sha256-KgL+0WvrZR7wBuHUPwSPZSyk3FitBTzS1ERQVj1cVLc=";
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
