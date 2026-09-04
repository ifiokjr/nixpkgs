{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
}:

let
  version = "0.153.2";
  tag = "rust-v${version}";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-kd/CcPDfuuwW2BTxqpDU8n503J43hOZABr7zt5/p4Jw=";
    "x86_64-apple-darwin" = "sha256-2EUV3yexQlWhxP4ognull1oJWlFP5nVTMOje5cwh7no=";
    "aarch64-unknown-linux-musl" = "sha256-h4aT+bNwMg6iF5P5nqH1aHt9mqHyxzPeaT2ewLqk5io=";
    "x86_64-unknown-linux-musl" = "sha256-6M0RYAcfcl0qEMq4EHPdaBj8iwljchJdJ+9uZv3wl54=";
  };
in
stdenv.mkDerivation {
  pname = "codex-cli";
  inherit version;

  src = fetchurl {
    url = "https://github.com/openai/codex/releases/download/${tag}/codex-${platformSuffix}.tar.gz";
    sha256 = hashes.${platformSuffix} or lib.fakeSha256;
  };

  dontBuild = true;
  dontStrip = stdenv.isDarwin;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp codex-* $out/bin/codex
    chmod +x $out/bin/codex

    runHook postInstall
  '';

  meta = with lib; {
    description = "OpenAI Codex CLI - AI coding assistant for the terminal";
    homepage = "https://github.com/openai/codex";
    license = licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ ];
    mainProgram = "codex";
    tags = [
      "cli"
      "dev-tool"
      "ai"
    ];
  };
}
