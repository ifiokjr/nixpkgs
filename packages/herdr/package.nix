{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.7.4";

  platformSuffix =
    {
      "aarch64-darwin" = "macos-aarch64";
      "x86_64-darwin" = "macos-x86_64";
      "aarch64-linux" = "linux-aarch64";
      "x86_64-linux" = "linux-x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "macos-aarch64" = "sha256-JJkuFiXb3LGDVKWeKZ5LJjwxJACzE5bNwHzUbtV/JKc=";
    "macos-x86_64" = "sha256-3fQwEzNS4XEkE9XYZbNKSFVG9GWIk/yJmGJX1lp1hag=";
    "linux-aarch64" = "sha256-VE4AAt5CgG0atkzN7zp+dBTyRxewtrAivJ5X0u79JqI=";
    "linux-x86_64" = "sha256-vA/ALUulAPnKwjU6Q+Z/4DZ4Xsym61U3jgUPrDwQMFk=";
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
