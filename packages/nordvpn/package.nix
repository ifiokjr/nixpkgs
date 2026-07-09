{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "10.6.0";
in
stdenv.mkDerivation {
  pname = "nordvpn";
  inherit version;

  src = fetchurl {
    url = "https://downloads.nordcdn.com/apps/macos/generic/NordVPN-OpenVPN/${version}/NordVPN.pkg";
    hash = "sha256-KSHwWgp96RfcveRP7m9LM6CeJxizAgATlnMadd6intY=";
  };

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    /usr/sbin/pkgutil --expand-full $src extracted

    mkdir -p $out/Applications
    find extracted -name "*.app" -maxdepth 4 -type d -not -path "*/.app/*" | while IFS= read -r app; do
      cp -r "$app" $out/Applications/
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "NordVPN macOS client";
    homepage = "https://nordvpn.com/";
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
      "security"
    ];
  };
}
