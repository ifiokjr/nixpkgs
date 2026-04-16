{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
  makeWrapper,
}:

let
  version = "2026.04.15-dccdccd";

  os = if stdenv.isDarwin then "darwin" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x64";

  hashes = {
    "darwin-arm64" = "sha256-Cpu4u4xYiUXLAtSAEKmAvUoDRwCR6DR/QLJRejs/BRQ=";
    "darwin-x64" = "sha256-kAdefsIyURGhixzmF1xi2N4kOUis43bwFtRCiJl8ghk=";
    "linux-x64" = "sha256-/51GfsQmqeW/iUCtHjTMr0/iZ+kYTn92paNQSi16SX4=";
    "linux-arm64" = "sha256-WqbxxhNA3Mh5rDAQqRagcvg0Klf8zPuLddS7dRgEYZg=";
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
