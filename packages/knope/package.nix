{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.23.0";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-puIxzH8CAyxbSa0UFJx9Ef1I8OJE+ftI1cTEf/sOOGM=";
    "x86_64-apple-darwin" = "sha256-5AO1vlMvt3I4uUiVVbxhzLNupLTH78Dd4fXlKQBnur4=";
    "aarch64-unknown-linux-musl" = "sha256-xodYscOwBzZ+pAwisbGwUnIFVyFZNa8JZ30VYQOWmLQ=";
    "x86_64-unknown-linux-musl" = "sha256-dqlwpeI3NEq8FL49437VDAIbZZqbZrP1Svx35tSKxQE=";
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

  meta = {
    description = "A command line tool for automating common development tasks";
    homepage = "https://knope.tech";
    license = lib.licenses.mit;
    mainProgram = "knope";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
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
