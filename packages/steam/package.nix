{
  stdenv,
  fetchurl,
  undmg,
  lib,
}:

stdenv.mkDerivation {
  pname = "steam";
  version = "4.0";

  src = fetchurl {
    url = "https://cdn.cloudflare.steamstatic.com/client/installer/steam.dmg";
    hash = "sha256-4av7qqe+Pg9IoODUwxMjPgWGGx0mrzKDDdyDi+iPJpE=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "Steam.app" $out/Applications/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Video game digital distribution service";
    homepage = "https://store.steampowered.com/";
    license = licenses.unfree;
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    tags = [
      "gui"
      "macos-app"
      "gaming"
    ];
  };
}
