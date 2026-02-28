{
  stdenv,
  fetchurl,
  undmg,
  lib,
}:

stdenv.mkDerivation {
  pname = "google-drive";
  version = "latest";

  src = fetchurl {
    url = "https://dl.google.com/drive-file-stream/5-percent/GoogleDrive.dmg";
    hash = "sha256-5exURzHot+M3F3YK8KvWSHxnwte9xkDamAkVj5zf+Tw=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    /usr/sbin/pkgutil --expand-full *.pkg extracted

    mkdir -p $out/Applications
    find extracted -name "*.app" -maxdepth 4 -type d -not -path "*/.app/*" | while IFS= read -r app; do
      cp -r "$app" $out/Applications/
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Google Drive desktop client for macOS";
    homepage = "https://www.google.com/drive/";
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
    ];
  };
}
