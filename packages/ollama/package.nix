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
  version = "0.24.0";

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
      hash = "sha256-gHNiTseYb5JZ8UoSNPWlgY9ihXZ/CLGM0Pu00RNlmbE=";
    };
    "linux-amd64" = {
      url = "https://github.com/ollama/ollama/releases/download/v${version}/ollama-linux-amd64.tar.zst";
      hash = "sha256-FcX41mugbg07RxnfiGhhLb1m4U6CdgkpuzVS4WV83Ns=";
    };
    "linux-arm64" = {
      url = "https://github.com/ollama/ollama/releases/download/v${version}/ollama-linux-arm64.tar.zst";
      hash = "sha256-bpo85fZOkzEpAuOcQg7DNiVfB4o2jKJembM50Ipt+ks=";
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
