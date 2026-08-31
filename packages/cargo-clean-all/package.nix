{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.6.5";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-taGiRYDvZL71RYOL9fj3YSLncfGhlgoFw8MPzfgRXP8=";
    "x86_64-apple-darwin" = "sha256-TH97OaOfRYa3bXF2MvXWk/U9zxKQ50eBOMVANA2mJQY=";
    "x86_64-unknown-linux-gnu" = "sha256-+vNIIfuDat+qdx33cP9xGgVEt5oz20OkHQiwVA9U+Y8=";
    "aarch64-unknown-linux-gnu" = "sha256-ikf12I84nyt9X9Wof2RrLALOjQs/146G5y4VImnsHgI=";
  };
in
stdenv.mkDerivation {
  pname = "cargo-clean-all";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/cargo-clean-all/${version}/cargo-clean-all-${platformSuffix}.tar.gz";
    hash = hashes.${platformSuffix} or (throw "No prebuilt for platform: ${platformSuffix}");
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    tar xzf $src -C $out/bin/
    chmod +x $out/bin/cargo-clean-all

    runHook postInstall
  '';

  meta = {
    description = "Recursively clean all Cargo projects in a directory that match the selected criteria";
    homepage = "https://github.com/dnlmlr/cargo-clean-all";
    license = lib.licenses.mit;
    mainProgram = "cargo-clean-all";
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
      "rust"
    ];
  };
}
