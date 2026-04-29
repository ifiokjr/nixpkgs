{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.22.4";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-AhMfKEMVyOzopO9poK/19lgwnU33O5XP374PvZ6c4lk=";
    "x86_64-apple-darwin" = "sha256-08N3/iKotESOQm5JVCePaPiRcKwpAJCHbd42OvpUzqQ=";
    "aarch64-unknown-linux-musl" = "sha256-Pl3vI4Ji89kPPxIC01oz7gqJn5rCO9yQEGYETMKL+ek=";
    "x86_64-unknown-linux-musl" = "sha256-tioYtww9ozmIKvnjJfeoOIySmSsh9rsxJd1GXLKTouE=";
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
