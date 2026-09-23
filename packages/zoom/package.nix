{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "7.2.1.88329";

  hashes = {
    "aarch64" = "sha256-PvOx/RMfDvS8yKHe0j+2mpKLNw3+QgE0P7MWyP7fv80=";
    "x86_64" = "sha256-Mqz06y/bGGsxHkJcMmZfyVrO2yvfssWT4/HZTiWvxK8=";
  };

  arch = if stdenv.isAarch64 then "aarch64" else "x86_64";
  urlPath = if stdenv.isAarch64 then "${version}/arm64" else version;
in
stdenv.mkDerivation {
  pname = "zoom";
  inherit version;

  src = fetchurl {
    url = "https://cdn.zoom.us/prod/${urlPath}/zoomusInstallerFull.pkg";
    hash = hashes.${arch} or lib.fakeHash;
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
    description = "Zoom video conferencing client";
    homepage = "https://zoom.us/";
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
      "communication"
    ];
  };
}
