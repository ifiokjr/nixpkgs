{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
  makeWrapper,
}:

let
  version = "2026.04.16-2d20146";

  os = if stdenv.isDarwin then "darwin" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x64";

  hashes = {
    "darwin-arm64" = "sha256-OlFDDRvNGVP0lDroSik4KozhAkl2lgsn1KR7434k2Yc=";
    "darwin-x64" = "sha256-g/V6XbF4PtzJaGr6zjz7FF0yu13SGP9ylx4j6OV+77U=";
    "linux-x64" = "sha256-unsSb7RiMM/1q0X+UUYLxC9mYM3JTAbKuXepU+oisEE=";
    "linux-arm64" = "sha256-IMTN3FrK7Qx9jIyqwukAz7u/kRw11E2q2zE8+6l8a8Q=";
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
