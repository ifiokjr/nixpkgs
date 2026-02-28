{
  stdenv,
  fetchurl,
  undmg,
  lib,
}:

let
  version = "2023.3";
in
stdenv.mkDerivation {
  pname = "gpg-suite";
  inherit version;

  src = fetchurl {
    url = "https://releases.gpgtools.org/GPG_Suite-${version}.dmg";
    hash = "sha256-V0aKStxV2VTq1P4fiLB+rBtwraQPy8gQdl/VIe8h7vE=";
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
    description = "GPG Suite for macOS - encryption, signing, and key management";
    homepage = "https://gpgtools.org/";
    license = licenses.gpl3;
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
