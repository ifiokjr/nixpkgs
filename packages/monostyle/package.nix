{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.3.28";

  # Upstream Linux binaries are statically linked against musl; the Rust
  # target triple is standard everywhere else.
  platformSuffix =
    if stdenv.hostPlatform.isLinux then
      builtins.replaceStrings [ "gnu" ] [ "musl" ] stdenv.hostPlatform.rust.rustcTarget
    else
      stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-3bAp3YyE3nzYXsELMXInbNpbUuSPCXYuo35RajJ0fXg=";
    "x86_64-apple-darwin" = "sha256-QjaRcgKI6qp5L0OZwRkJ36PdSC3HTIoCffVzyRR7eBk=";
    "aarch64-unknown-linux-musl" = "sha256-GoRIVpuBq8njyRYnE8QxuiMENa/gndY+E+pbRzZYDuo=";
    "x86_64-unknown-linux-musl" = "sha256-fIY61lQBH6Gk0oDJJ4y/RRd7ANh52WZ9newqxCaBI+Q=";
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
