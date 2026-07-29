{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
}:

let
  version = "0.146.0";
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
    "aarch64-apple-darwin" = "sha256-J1ATLTAOZPHb/7lePZE/2cnceBK8jhvOXGE1cki3kp4=";
    "x86_64-apple-darwin" = "sha256-cQ1yew+itKshiesb3Fq0AXfBaClq8mSRPrerPOhI0Es=";
    "aarch64-unknown-linux-musl" = "sha256-l1uskVYqvu3rj3ljbVGoZkmzHzSp3mo7ywWVZbbPH4c=";
    "x86_64-unknown-linux-musl" = "sha256-W6O5QFVDlTCB9mHQhU0mb3biq75R1BNJNVo23nZzd2o=";
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
