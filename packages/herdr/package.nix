{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.8.0";

  platformSuffix =
    {
      "aarch64-darwin" = "macos-aarch64";
      "x86_64-darwin" = "macos-x86_64";
      "aarch64-linux" = "linux-aarch64";
      "x86_64-linux" = "linux-x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "macos-aarch64" = "sha256-1Tqfk/zP38xVYyknv1EAL1rdCqeZC831CP+9hKxlgXg=";
    "macos-x86_64" = "sha256-d8ta/WyPyqrzvCjkdOwBwgkzGtCAlOINf4qpsLt41kk=";
    "linux-aarch64" = "sha256-9kesZkaNnvvGQv5TT7KERo8K6mBkFgb8AI38DYKjyoc=";
    "linux-x86_64" = "sha256-uHLqfkD6LLF+hXrJtisb8m23tAPGIvXS8/WzX26azSg=";
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
