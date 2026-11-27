{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.22.1";
  tag = "v${version}";

  # Upstream Linux binaries are statically linked against musl; the Rust
  # target triple is standard everywhere else.
  platformSuffix =
    if stdenv.hostPlatform.isLinux then
      builtins.replaceStrings [ "gnu" ] [ "musl" ] stdenv.hostPlatform.rust.rustcTarget
    else
      stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-c9Y3NW0eg5gWzpGbtPbKqhNw3M7j28Dq7jpcNbkxiqA=";
    "x86_64-apple-darwin" = "sha256-9FO7IeS8H2f32cjnTOv8LaXWD8hEsStFOg/EUeixaBE=";
    "aarch64-unknown-linux-musl" = "sha256-ecHCYmwFarT6IjNKpF6G0zhds9OE+JphzGYVBvtAzSE=";
    "x86_64-unknown-linux-musl" = "sha256-8N3yz4sYjN+jIcdp7Bg/k13ajz4V2wiCl/Umt/lF9RU=";
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

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/monochange --version
    runHook postInstallCheck
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
