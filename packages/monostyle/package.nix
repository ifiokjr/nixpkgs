{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.2.0";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-5g/RO+Td9VTinY76aEKk8pUholpsMNvuDbSmwBpR4Es=";
    "x86_64-apple-darwin" = "sha256-S/p8mlkyd6c2lYcAJlSav1kpOg9cUX0DUpWHoXrXeu0=";
    "aarch64-unknown-linux-musl" = "sha256-AQQuV3E+jCAp3PbMsZ67uBGbTx3wnpT7sCBi0eG8dWQ=";
    "x86_64-unknown-linux-musl" = "sha256-/Jg7Jvo8wlpsjGVMAbO1ZvYKR0ztElg2s/hKwQMozK8=";
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
