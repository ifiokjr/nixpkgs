{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
  makeWrapper,
}:

let
  version = "2026.04.14-ee4b43a";

  os = if stdenv.isDarwin then "darwin" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x64";

  hashes = {
    "darwin-arm64" = "sha256-8vBn1YaNepS/9Xt0phZ1JmNFfB7RcZ9eOjxV08Dln70=";
    "darwin-x64" = "sha256-287mVg4Mw8u5fcpDh5ZXuhPu+IY1irFzKdsEguZf9Xo=";
    "linux-x64" = "sha256-1cBPPPmV9gORWumGL4NevRSOsuZ2K5B177Lg0+djoCc=";
    "linux-arm64" = "sha256-bdYrfyBvQiM7X7NUmOnk/jRU3jmWn/HeqG4kTAuweuQ=";
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
