{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.23.1";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-PzKhN8sGqlcKztOqcmaxrrImUKJvbPlx+sk/6t4wAmI=";
    "x86_64-apple-darwin" = "sha256-FoEzpRxFPqZk/zkdFIMRAvIWv6nrETayeK9uItu9wmA=";
    "aarch64-unknown-linux-musl" = "sha256-ar8AhfTMDFDvOyW3Eet3Nqcu+XWVDIz3m6m7g+JzBBY=";
    "x86_64-unknown-linux-musl" = "sha256-4w9rabQgD+WvTkMG8SjMPhheUj0MQiETTLiz7CQRLHI=";
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
