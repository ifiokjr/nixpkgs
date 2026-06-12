{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.6.10";

  platformSuffix =
    {
      "aarch64-darwin" = "macos-aarch64";
      "x86_64-darwin" = "macos-x86_64";
      "aarch64-linux" = "linux-aarch64";
      "x86_64-linux" = "linux-x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "macos-aarch64" = "sha256-9Iu6r9YLOjPXg+yk3+ckOj+W5VflUkD27VPdC5tzZws=";
    "macos-x86_64" = "sha256-yZgmuII2OVHyJAXYiewMVXSIcJODDTkMmbKGwJSaDHM=";
    "linux-aarch64" = "sha256-sxRKQd82TwVBu73+hA+mHb1n2vbjE+4xf+SV0sz0kno=";
    "linux-x86_64" = "sha256-eNKY1aHvB2tGB+jjyS2Y9d6fDLMNrzGqkQoabpq7T6E=";
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
