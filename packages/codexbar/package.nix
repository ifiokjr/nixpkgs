{
  stdenv,
  fetchurl,
  unzip,
  lib,
}:

stdenv.mkDerivation {
  pname = "codexbar";
  version = "0.23";

  src = fetchurl {
    url = "https://github.com/steipete/CodexBar/releases/download/v0.17.0/CodexBar-0.17.0.zip";
    hash = "sha256-pEuMcsDgjZ4OjKzvRqSC/yXTuJt3rB4/LWWgp8D2lxM=";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    find . -name "*.app" -maxdepth 2 -type d -not -path "*/.app/*" | while IFS= read -r app; do
      cp -r "$app" $out/Applications/
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "macOS menu bar app showing AI coding tool usage and limits";
    homepage = "https://codexbar.app";
    license = licenses.mit;
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    tags = [
      "gui"
      "macos-app"
      "dev-tool"
      "ai"
    ];
  };
}
