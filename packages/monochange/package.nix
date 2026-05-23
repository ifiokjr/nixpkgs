{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.6.0";
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
    "aarch64-apple-darwin" = "sha256-HT9TtEvbcvKr+G4iE9AkpdovVN+FGfv1YNp9uOMEJ9s=";
    "x86_64-apple-darwin" = "sha256-qCXgXgogOcRtjfUh23ps7SwTlgS/4Z751DCjiaTHRdw=";
    "aarch64-unknown-linux-musl" = "sha256-6p0vg1YVec13Bq+3jlMB4PhbR3oQKKZFoMbaEjXFOyE=";
    "x86_64-unknown-linux-musl" = "sha256-SXzhszBlLOIicYp5KkSkT/FtPpGhFRtBvbENHy+sSEg=";
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
      "x86_64-darwin"
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
