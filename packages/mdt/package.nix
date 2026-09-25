{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.9.5";
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
    "aarch64-apple-darwin" = "sha256-I6ftQDX5Mch5pnuSKVlnky84/olR1g5hwZmJmUxOKKc=";
    "x86_64-apple-darwin" = "sha256-mdGw22IZHWYdPj0ep71Yr4hVieF/zB9u/UBGr67dD+A=";
    "aarch64-unknown-linux-musl" = "sha256-MCMqPJZw3MGYMyba81C4gwxoMBxGDHbsXGBhRaz9EJ4=";
    "x86_64-unknown-linux-musl" = "sha256-VDLEsJDdZdm+0H4ZXgnGt96fxVsFIf0sHCKIPd9Wkqg=";
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
