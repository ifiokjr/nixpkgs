{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "604.0.0";

  # Rust-style target triple for the host platform, e.g. aarch64-apple-darwin:
  # the build-swift-prebuilt workflow names its release archives this way.
  platformSuffix = stdenv.hostPlatform.rust.rustcTarget;

  # Upstream publishes no binaries, and nixpkgs' swift-format needs a Swift
  # compiler built from source that cache.nixos.org does not always carry.
  # These archives are built once per version by
  # .github/workflows/build-swift-prebuilt.yml and attached to this repo's
  # `prebuilt/swift-format/<version>` release.
  hashes = {
    "aarch64-apple-darwin" = "sha256-X/8ARCyDXTl75dS70A99qzh18+USw1LVdD6xvsglJxs=";
    "x86_64-apple-darwin" = "sha256-ng20APUmniDgm0fmk6N2NV/c4LWeFGyBoBr3I9HRJ4w=";
    "aarch64-unknown-linux-gnu" = "sha256-4wP75uAR3ojWwgYTvX0QZoogiNA5Odk67csSBpMA+4E=";
    "x86_64-unknown-linux-gnu" = "sha256-5xog0rVNbFw9O3AuBlWotba+3pCLhkxSRzPFX0Wsa2c=";
  };
in
stdenv.mkDerivation {
  pname = "swift-format";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/swift-format/${version}/swift-format-${platformSuffix}.tar.gz";
    hash = hashes.${platformSuffix} or lib.fakeHash;
  };

  sourceRoot = ".";

  # The Linux binaries link the Swift runtime and Foundation statically and
  # need only glibc, libstdc++ and libgcc_s. The macOS binaries use the Swift
  # runtime and Foundation that ship with the OS.
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontBuild = true;
  # The arm64 Darwin binary carries the linker's ad-hoc signature; stripping it
  # invalidates the signature on Apple Silicon.
  dontStrip = stdenv.hostPlatform.isDarwin;

  installPhase = ''
    runHook preInstall

    install -Dm755 swift-format $out/bin/swift-format
    install -Dm644 LICENSE.txt $out/share/licenses/swift-format/LICENSE.txt

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/swift-format --version
    printf 'let  x=[1,2]\n' > smoke.swift
    formatted=$($out/bin/swift-format format smoke.swift)
    if [ "$formatted" != "let x = [1, 2]" ]; then
      echo "swift-format: unexpected output: $formatted" >&2
      exit 1
    fi

    runHook postInstallCheck
  '';

  meta = {
    description = "Formatting technology for Swift source code";
    homepage = "https://github.com/swiftlang/swift-format";
    license = lib.licenses.asl20;
    mainProgram = "swift-format";
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
      "swift"
    ];
  };
}
