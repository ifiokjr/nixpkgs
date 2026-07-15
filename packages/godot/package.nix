{
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  makeWrapper,
  lib,
}:

let
  version = "4.7.1-stable";

  platformSuffix =
    {
      "aarch64-darwin" = "macos.universal";
      "x86_64-darwin" = "macos.universal";
      "aarch64-linux" = "linux.arm64";
      "x86_64-linux" = "linux.x86_64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "linux.arm64" = "sha256-j1Jxec1K5YtAL6Jl/oF9xQXltrFFdPMJ7+VxE75WKsE=";
    "linux.x86_64" = "sha256-x/8U/ShHLI1PGTBD3jAnjc9+UkGh3PdWawLiet2qM7o=";
    "macos.universal" = "sha256-iXy3+XmXlscXrnXzFEau2IPckrHWw7M9iTzHhD//L6k=";
  };
in
stdenv.mkDerivation {
  pname = "godot";
  inherit version;

  src = fetchurl {
    url = "https://github.com/godotengine/godot/releases/download/${version}/Godot_v${version}_${platformSuffix}.zip";
    sha256 = hashes.${platformSuffix} or lib.fakeSha256;
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ]
  ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];

  sourceRoot = ".";
  dontBuild = true;
  dontStrip = stdenv.isDarwin;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    ${
      if stdenv.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -R Godot.app $out/Applications/

          chmod +x $out/Applications/Godot.app/Contents/MacOS/Godot
          makeWrapper $out/Applications/Godot.app/Contents/MacOS/Godot $out/bin/godot
        ''
      else
        ''
          install -m 755 Godot_v${version}_${platformSuffix} $out/bin/godot
        ''
    }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Free and open-source 2D and 3D game engine";
    homepage = "https://godotengine.org/";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "godot";
    tags = [
      "gui"
      "game-development"
      "engine"
    ];
  };
}
