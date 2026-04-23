{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.7.0";
  tag = "v${version}";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-pgJjrD3W8Is00zBTfBBJ4I0vNtdj3Z2K+FYWTCHsLKE=";
    "x86_64-apple-darwin" = "sha256-ehK1h1o9R9arR4fQSiDJbsa+4xStVbInoaty8PiRV3E=";
    "aarch64-unknown-linux-musl" = "sha256-Gy187xh3SOBiAgCl2yJXnPmWz2TeuTBcHkBaIulIkNM=";
    "x86_64-unknown-linux-musl" = "sha256-d4AuyUfuD8rXiL9cmUDw32w+HEojIeNnNrCEBGUDQy4=";
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
  dontStrip = stdenv.isDarwin;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp mdt $out/bin/mdt
    chmod +x $out/bin/mdt

    runHook postInstall
  '';

  meta = {
    description = "CLI that updates markdown content anywhere using comments as template tags";
    homepage = "https://github.com/ifiokjr/mdt";
    license = lib.licenses.unlicense;
    mainProgram = "mdt";
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
