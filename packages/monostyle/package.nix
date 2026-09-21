{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.1.0";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-dsr+gcqE7664ak3aoF+WjetFUqJ8wyA1ykvqdHNHoII=";
    "x86_64-apple-darwin" = "sha256-K4bgwcTZFjEHz3HUNdqZ7kiMKcQtLD5nMpCg9/ZA8hc=";
    "aarch64-unknown-linux-musl" = "sha256-QIT67Jimlh46RLctx3iL9Bew616TEu/lO1OnY0jaOiI=";
    "x86_64-unknown-linux-musl" = "sha256-9SgOlZsg567w2k8ariSrcXHL87qbB8VBSe+6s9a8qJ0=";
  };
in
stdenv.mkDerivation {
  pname = "monostyle";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ifiokjr/monostyle/releases/download/v${version}/monostyle-${platformSuffix}";
    hash = hashes.${platformSuffix} or (throw "No prebuilt for platform: ${platformSuffix}");
  };

  # Release assets are bare executables, not archives. The musl Linux builds are
  # statically linked, so no autoPatchelf or interpreter plumbing is needed.
  dontUnpack = true;
  dontBuild = true;
  # The macOS binaries are code-signed; stripping invalidates the signature.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/monostyle
    chmod +x $out/bin/monostyle

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/monostyle --version

    runHook postInstallCheck
  '';

  meta = {
    description = "Score the complexity and readability of a codebase, a file, or a function";
    homepage = "https://github.com/ifiokjr/monostyle";
    license = lib.licenses.unlicense;
    mainProgram = "monostyle";
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
      "lint"
    ];
  };
}
