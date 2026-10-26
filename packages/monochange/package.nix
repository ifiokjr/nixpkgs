{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.21.0";
  tag = "v${version}";

  # Upstream Linux binaries are statically linked against musl; the Rust
  # target triple is standard everywhere else.
  platformSuffix =
    if stdenv.hostPlatform.isLinux then
      builtins.replaceStrings [ "gnu" ] [ "musl" ] stdenv.hostPlatform.rust.rustcTarget
    else
      stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-LzHU9SBphHdl7v2bpoo13Fb/6RJVLfla8M8FaT6Nw8Y=";
    "x86_64-apple-darwin" = "sha256-bRl+hArKnsGB8Htbj5+NguJgKeZM5tT/2fcgQ0erVS4=";
    "aarch64-unknown-linux-musl" = "sha256-5Lb4v2G0nuQNADlQ6N1M5X7OoypLJ1uS1dYYPRXUen8=";
    "x86_64-unknown-linux-musl" = "sha256-lrzUNXouiRZ1UQIspeEkMVVGVljyJ/ebKoff8z4GZVM=";
  };
in
stdenv.mkDerivation {
  pname = "monochange";
  inherit version;

  src = fetchurl {
    url = "https://github.com/monochange/monochange/releases/download/${tag}/monochange-${platformSuffix}-${tag}.tar.gz";
    sha256 = hashes.${platformSuffix} or lib.fakeSha256;
  };

  dontBuild = true;
  dontStrip = stdenv.isDarwin;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp monochange $out/bin/monochange
    chmod +x $out/bin/monochange
    ln -s $out/bin/monochange $out/bin/mc

    runHook postInstall
  '';

  meta = {
    description = "Manage versions and releases for your multiplatform, multilanguage monorepo";
    homepage = "https://ifiokjr.github.io/monochange/";
    license = lib.licenses.unlicense;
    mainProgram = "monochange";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "dev-tool"
      "release"
      "monorepo"
    ];
  };
}
