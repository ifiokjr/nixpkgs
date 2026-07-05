{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "0.9.0";
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
    "aarch64-apple-darwin" = "sha256-cgS4z6B15IzNHuXMp3yXSLASMPVqsfb32p7331cz1Uc=";
    "x86_64-apple-darwin" = "sha256-P0Nc5HAgKKEm9ZJgEAY0mLG+k5FRNZuCDv7Vyt7xkRU=";
    "aarch64-unknown-linux-musl" = "sha256-d7xvC2tLdsYaxp6XSA3pQQ1O9Q96MDIAgjwWhvcD5K8=";
    "x86_64-unknown-linux-musl" = "sha256-FIoxs2T0GD5IWSOMzPo7929AWY1tDM2+72gAjDJSV4g=";
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
