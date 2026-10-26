{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.23.2";

  # Upstream Linux binaries are statically linked against musl; the Rust
  # target triple is standard everywhere else.
  platformSuffix =
    if stdenv.hostPlatform.isLinux then
      builtins.replaceStrings [ "gnu" ] [ "musl" ] stdenv.hostPlatform.rust.rustcTarget
    else
      stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-nKBAPY5SivSLZFHrFO9NMRC1cKMj52G6uJlPwUwE3Ek=";
    "x86_64-apple-darwin" = "sha256-41zThXR3E0oOvZOV+pft3N9BIX9vjkJjadRPG5wW32M=";
    "aarch64-unknown-linux-musl" = "sha256-Zex3S9N9fQMBAMiWvX/GNbEayt4PsDn/y1fCtWvp2hE=";
    "x86_64-unknown-linux-musl" = "sha256-xk9igeAS/I4Ebr1vML52xYPoi5rVWwDHsYCbAw25Lu4=";
  };
in
stdenv.mkDerivation {
  pname = "knope";
  inherit version;

  src = fetchurl {
    url = "https://github.com/knope-dev/knope/releases/download/knope/v${version}/knope-${platformSuffix}.tgz";
    hash = hashes.${platformSuffix} or lib.fakeHash;
  };

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -R ./* $out/bin/
    chmod +x $out/bin/knope

    runHook postInstall
  '';

  meta = {
    description = "A command line tool for automating common development tasks";
    homepage = "https://knope.tech";
    license = lib.licenses.mit;
    mainProgram = "knope";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "dev-tool"
    ];
  };
}
