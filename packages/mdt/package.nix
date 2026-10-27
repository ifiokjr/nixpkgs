{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.9.7";
  tag = "v${version}";

  # Upstream Linux binaries are statically linked against musl; the Rust
  # target triple is standard everywhere else.
  platformSuffix =
    if stdenv.hostPlatform.isLinux then
      builtins.replaceStrings [ "gnu" ] [ "musl" ] stdenv.hostPlatform.rust.rustcTarget
    else
      stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-QmJuaUw7/4/1dyTNxXsceMq7dDpafMGxpJ7F1k5sQv8=";
    "x86_64-apple-darwin" = "sha256-zt5Z+37kP/JBF53AVBu4JVAWdfeBotzzAz5/qSwREhw=";
    "aarch64-unknown-linux-musl" = "sha256-JThGfvW/UvfIVdClSTvCYxeyI1nzmuyYLRUB81RdL/I=";
    "x86_64-unknown-linux-musl" = "sha256-45Na4ih7B7GmqxAmT3iu++Ykg4lnQBwgVI/3yRBJzGA=";
  };
in
stdenv.mkDerivation {
  pname = "mdt";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ifiokjr/mdt/releases/download/${tag}/mdt-${platformSuffix}-${tag}.tar.gz";
    sha256 = hashes.${platformSuffix} or lib.fakeSha256;
  };

  dontBuild = true;
  dontStrip = stdenv.hostPlatform.isDarwin;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp mdt $out/bin/mdt
    chmod +x $out/bin/mdt

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/mdt --version
    runHook postInstallCheck
  '';

  meta = {
    description = "CLI that updates markdown content anywhere using comments as template tags";
    homepage = "https://github.com/ifiokjr/mdt";
    license = lib.licenses.unlicense;
    mainProgram = "mdt";
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
