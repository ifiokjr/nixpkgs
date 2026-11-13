{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.24.0";

  # Upstream Linux binaries are statically linked against musl; the Rust
  # target triple is standard everywhere else.
  platformSuffix =
    if stdenv.hostPlatform.isLinux then
      builtins.replaceStrings [ "gnu" ] [ "musl" ] stdenv.hostPlatform.rust.rustcTarget
    else
      stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-9OycIVtOZkffDrZkYzqLW3EY05RhnkNcJNmi6ZMnlTY=";
    "x86_64-apple-darwin" = "sha256-fQqKVWYktu8IAqfP1bbAWrZmiwQPsJq5i/eFX3QF25A=";
    "aarch64-unknown-linux-musl" = "sha256-JVtcUXSs2DhzIef/tOFuJR/L70rG+eZL87b8s5xZaqw=";
    "x86_64-unknown-linux-musl" = "sha256-JWoei/r7Y/Sei2SSQ3Z6rg9DwajxCaaaJRmT3L1qDDg=";
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

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/knope --version
    runHook postInstallCheck
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
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "dev-tool"
    ];
  };
}
