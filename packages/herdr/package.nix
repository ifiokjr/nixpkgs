{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.6.6";

  platformSuffix =
    {
      "aarch64-darwin" = "macos-aarch64";
      "x86_64-darwin" = "macos-x86_64";
      "aarch64-linux" = "linux-aarch64";
      "x86_64-linux" = "linux-x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "macos-aarch64" = "sha256-VDf4fKx02whbvFFhmAT7YQZvSfd8JX8zMzEDW75ebD8=";
    "macos-x86_64" = "sha256-9QeO6Lr5jyt9iRhgZerKunm5E59mEvxVQJJ8gZq7Z8U=";
    "linux-aarch64" = "sha256-aYI3XQGRAW4myM4XNC6lJHiPbDrrTzlJ0AFfUeM9FtI=";
    "linux-x86_64" = "sha256-DQwKOUaUNO+zYw1yWfn5FGO61yekwQ7RxAwG0wvA6qw=";
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
