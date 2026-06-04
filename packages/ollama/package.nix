{
  stdenv,
  fetchurl,
  unzip,
  zstd,
  autoPatchelfHook,
  zlib,
  lib,
}:

let
  version = "0.30.4";

  platformKey =
    {
      "aarch64-darwin" = "darwin";
      "x86_64-darwin" = "darwin";
      "aarch64-linux" = "linux-arm64";
      "x86_64-linux" = "linux-amd64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  assets = {
    "darwin" = {
      url = "https://github.com/ollama/ollama/releases/download/v${version}/Ollama-darwin.zip";
      hash = "sha256-TsUpe9RkK0yu18Tc9vYw8i8pd2hEZL96Q496LPt2InQ=";
    };
    "linux-amd64" = {
      url = "https://github.com/ollama/ollama/releases/download/v${version}/ollama-linux-amd64.tar.zst";
      hash = "sha256-eOMXiJyQfZhTM2yNg09CTH3GzNiVh3L0T633j0IeqQc=";
    };
    "linux-arm64" = {
      url = "https://github.com/ollama/ollama/releases/download/v${version}/ollama-linux-arm64.tar.zst";
      hash = "sha256-h3mBSZqyzMj/1nSlwv4XiOvWekwx3405n8o6SIBy5VE=";
    };
  };
in
stdenv.mkDerivation {
  pname = "ollama";
  inherit version;

  src = fetchurl (assets.${platformKey});

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  dontFixup = stdenv.isDarwin;

  nativeBuildInputs =
    lib.optionals stdenv.isDarwin [ unzip ]
    ++ lib.optionals stdenv.isLinux [
      autoPatchelfHook
      zstd
    ];
  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc.lib
    zlib
  ];

  autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.isLinux [ "libcuda.so.1" ];

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.isDarwin then
        ''
          mkdir -p $out/Applications $out/bin
          unzip -q $src -d extracted
          cp -R extracted/Ollama.app $out/Applications/

          chmod +x $out/Applications/Ollama.app/Contents/MacOS/Ollama
          chmod +x $out/Applications/Ollama.app/Contents/Resources/ollama
          ln -s $out/Applications/Ollama.app/Contents/Resources/ollama $out/bin/ollama

          printf '%s\n' '#!${stdenv.shell}' 'exec "$out/Applications/Ollama.app/Contents/MacOS/Ollama" "$@"' > $out/bin/ollama-app
          chmod +x $out/bin/ollama-app
        ''
      else
        ''
          mkdir -p $out
          tar --use-compress-program=unzstd -xf $src -C $out

          chmod +x $out/bin/ollama
          printf '%s\n' '#!${stdenv.shell}' 'exec "$out/bin/ollama" "$@"' > $out/bin/ollama-app
          chmod +x $out/bin/ollama-app
        ''
    }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Run local LLMs with Ollama via CLI and desktop app";
    homepage = "https://ollama.com/";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "ollama";
    tags = [
      "cli"
      "gui"
      "ai"
      "llm"
    ];
  };
}
