{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
}:

let
  version = "0.171.0";
  tag = "rust-v${version}";

  # Upstream Linux binaries are statically linked against musl; the Rust
  # target triple is standard everywhere else.
  platformSuffix =
    if stdenv.hostPlatform.isLinux then
      builtins.replaceStrings [ "gnu" ] [ "musl" ] stdenv.hostPlatform.rust.rustcTarget
    else
      stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-lBTIyWfxELEegyTAz6KyDwEglO+JARClYcku5TWiaBo=";
    "x86_64-apple-darwin" = "sha256-b5sRRP+qZKoSvzDzEkBbJmuExDO66fBwvhAkV2LHqkQ=";
    "aarch64-unknown-linux-musl" = "sha256-vPULg2OF5RvSl2qyu+krGwihy+N3EuuNvjeKp40khxw=";
    "x86_64-unknown-linux-musl" = "sha256-Abqi5HgJ+Fl75bL4q9Tk3+P7W8tuUEwvuqrZcFbBXo0=";
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

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/codex --version
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "OpenAI Codex CLI - AI coding assistant for the terminal";
    homepage = "https://github.com/openai/codex";
    license = licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
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
