{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.9.2";
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
    "aarch64-apple-darwin" = "sha256-+Lx2pKt+zsh12fC4Vsx5cV48cb1NgnVjj4IV0x6qeR0=";
    "x86_64-apple-darwin" = "sha256-0WrxKNQT09yRys91BFDmLn8sVgF3Ws47PMW0p4hh47A=";
    "aarch64-unknown-linux-musl" = "sha256-xNelcA5CdCS1EnT4xHlG8eLRD2SExubNbs7qUD/aokk=";
    "x86_64-unknown-linux-musl" = "sha256-GaiHm7KS1+9vfvvn4xmUo+fUtCkGRNffHjg50EMO+nM=";
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
