{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.28.2";
  tag = "ironclaw-v${version}";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-DnKCuEaQ684J421S3xICYskHX8inuHaSx6YCGtCCGC4=";
    "x86_64-apple-darwin" = "sha256-BhN6ZX445ULdJCEbm+kPssREnPeFBcDloBJdZzI+gVI=";
    "aarch64-unknown-linux-gnu" = "sha256-PtJcmIekFIXsSVpTSUgll5ZtA8Xtlw1n9DP+FSNmjI8=";
    "x86_64-unknown-linux-musl" = "sha256-yyKNpVxct9yzhzi2czAgZF1JyHhoFk8S+oSA4zODR3Q=";
  };
in
stdenv.mkDerivation {
  pname = "ironclaw";
  inherit version;

  src = fetchurl {
    url = "https://github.com/nearai/ironclaw/releases/download/${tag}/ironclaw-${platformSuffix}.tar.gz";
    sha256 = hashes.${platformSuffix} or lib.fakeSha256;
  };

  dontBuild = true;
  dontStrip = stdenv.isDarwin;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ironclaw-${platformSuffix}/ironclaw $out/bin/ironclaw
    chmod +x $out/bin/ironclaw

    runHook postInstall
  '';

  meta = {
    description = "AI-powered coding agent with mission orchestration, WASM tools, and multi-channel support";
    homepage = "https://github.com/nearai/ironclaw";
    license = lib.licenses.asl20;
    mainProgram = "ironclaw";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "dev-tool"
      "ai"
    ];
  };
}
