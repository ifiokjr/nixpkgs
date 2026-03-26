{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
  makeWrapper,
}:

let
  version = "2026.03.25-933d5a6";

  os = if stdenv.isDarwin then "darwin" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x64";

  hashes = {
    "darwin-arm64" = "sha256-1QTjO99QvdviRsos5pvOrfR2L1fwj6nBh0nPqcY1qnI=";
    "darwin-x64" = "sha256-JDUMpdFEnPgYJWjXXIsdqOVbkw6DbcahbcCVYjbqKxo=";
    "linux-x64" = "sha256-sLNUNy95Ro953X4tha0fPj/M8DRN4Txn34m2kWa/J/U=";
    "linux-arm64" = "sha256-+Gk7XDf294AxHYwig2s7h4DSgy2Sf5F5Va+c5ufDbtw=";
  };

  platformKey = "${os}-${arch}";
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  inherit version;

  src = fetchurl {
    url = "https://downloads.cursor.com/lab/${version}/${os}/${arch}/agent-cli-package.tar.gz";
    sha256 = hashes.${platformKey} or lib.fakeSha256;
  };

  sourceRoot = "dist-package";
  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/cursor-cli $out/bin
    cp -r . $out/lib/cursor-cli/

    chmod +x $out/lib/cursor-cli/cursor-agent
    chmod +x $out/lib/cursor-cli/cursor-askpass
    chmod +x $out/lib/cursor-cli/node
    chmod +x $out/lib/cursor-cli/rg
    chmod +x $out/lib/cursor-cli/cursorsandbox 2>/dev/null || true
    chmod +x $out/lib/cursor-cli/spawn-helper 2>/dev/null || true

    ln -s $out/lib/cursor-cli/cursor-agent $out/bin/cursor-agent
    ln -s $out/lib/cursor-cli/cursor-agent $out/bin/agent

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cursor AI CLI agent for terminal-based development";
    homepage = "https://cursor.com/cli";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ ];
    mainProgram = "cursor-agent";
    tags = [
      "cli"
      "dev-tool"
      "ai"
    ];
  };
}
