{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.19.1";
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
    "aarch64-apple-darwin" = "sha256-LtJqBvsLMX2V15X1pgYp6kouKnXGvHN6EEhUJ140TBI=";
    "x86_64-apple-darwin" = "sha256-tUSIS+zTn52SM7U4ANR8vwmQUHs/HxmSKHqBA0LUMLw=";
    "aarch64-unknown-linux-musl" = "sha256-vcwzm2g1SsXgNCDbCZe+eGKB05Z/oFd2eZteI2iLRGk=";
    "x86_64-unknown-linux-musl" = "sha256-wgsvdplSVf1DDD2CBr1ej+4yr3rmHSwdOI12csLSHWo=";
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
