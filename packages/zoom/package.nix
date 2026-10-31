{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "7.2.5.90525";

  hashes = {
    "aarch64" = "sha256-TCbr7YvSnOJYrJ2+Dysyf60KBzQkbqWIM5osxf0QUz4=";
    "x86_64" = "sha256-F1DDFtFe1p2PyL/TcgssNmKRvSkUTWy3wAMs2bkhFMs=";
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
