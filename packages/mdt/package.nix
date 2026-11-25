{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.9.9";
  tag = "v${version}";

  # Upstream Linux binaries are statically linked against musl; the Rust
  # target triple is standard everywhere else.
  platformSuffix =
    if stdenv.hostPlatform.isLinux then
      builtins.replaceStrings [ "gnu" ] [ "musl" ] stdenv.hostPlatform.rust.rustcTarget
    else
      stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-4G5wdSRyOm5sXCGBR/zzU1QXfEwehVM6oJ/7B3N6bPs=";
    "x86_64-apple-darwin" = "sha256-JGILmU50DYyh1Aia5ZI3VL3UK6ItKPZDMBhZEcwPgiE=";
    "aarch64-unknown-linux-musl" = "sha256-wvGYRdbkkMcGn+65pJP4B0TBGQVegjGoPoE2mG0P6yQ=";
    "x86_64-unknown-linux-musl" = "sha256-YW0ga5kKgVvkm++lDiun+KFUKmflyyZqzzV/DzBXeOg=";
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
