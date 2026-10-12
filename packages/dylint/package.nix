{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  autoPatchelfHook,
  openssl,
  zlib,
  pkg-config,
}:

let
  version = "6.1.1";
  tag = "v${version}";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  # Linux prebuilt hashes from upstream releases
  upstreamLinuxHashes = {
    "cargo-dylint-aarch64-unknown-linux-gnu" = "sha256-BLsOAOrBh6nRc6pu4ty47upqrL64vL+V/XB8Qx2tck8=";
    "dylint-link-aarch64-unknown-linux-gnu" = "sha256-Xf+1SCUCknw0GExAlBOjPRpWP4AzCoD2hWzFT1mgSoU=";
    "cargo-dylint-x86_64-unknown-linux-gnu" = "sha256-akqcFj3RIJM0e2TYPkIC00IcYOz8SlqaELNlSudCzsQ=";
    "dylint-link-x86_64-unknown-linux-gnu" = "sha256-5XDh1v/mUolgUh+B5xmyKjlk4ZcWiKASrY9QGJWUNW0=";
  };

  hasUpstreamBinary = stdenv.isLinux;

  meta = {
    description = "Dylint tools for running Rust lints and building Dylint libraries";
    homepage = "https://github.com/trailofbits/dylint";
    license = [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    mainProgram = "cargo-dylint";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance =
      if hasUpstreamBinary then [ lib.sourceTypes.binaryNativeCode ] else [ lib.sourceTypes.fromSource ];
    tags = [
      "cli"
      "dev-tool"
      "rust"
    ];
  };

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "dylint";
    rev = tag;
    hash = "sha256-wOuQvE/u0Mp04QhQ25Wp8YZK7p24eA9ooRJ0f6XS6xU=";
  };

  sourceBuild = rustPlatform.buildRustPackage {
    pname = "dylint";
    inherit version src;
    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };
    cargoBuildFlags = [
      "--package"
      "cargo-dylint"
      "--package"
      "dylint-link"
    ];
    cargoInstallFlags = [
      "--package"
      "cargo-dylint"
      "--package"
      "dylint-link"
    ];
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [
      openssl
      zlib
    ];
    doCheck = false;
    doInstallCheck = true;
    # cargo-dylint is a rustup-style proxy and refuses to run without a
    # RUSTUP_TOOLCHAIN; any value is fine for --help.
    installCheckPhase = "RUSTUP_TOOLCHAIN=stable $out/bin/cargo-dylint --help > /dev/null";
    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.fromSource ];
    };
  };

  # Only evaluated when hasUpstreamBinary (Linux) — prevents fetchurl
  # from trying to access upstreamLinuxHashes for macOS platform keys
  cargoDylintSrc = fetchurl {
    url = "https://github.com/trailofbits/dylint/releases/download/${tag}/cargo-dylint-${platformSuffix}-${tag}.tar.gz";
    hash = upstreamLinuxHashes."cargo-dylint-${platformSuffix}";
  };

  dylintLinkSrc = fetchurl {
    url = "https://github.com/trailofbits/dylint/releases/download/${tag}/dylint-link-${platformSuffix}-${tag}.tar.gz";
    hash = upstreamLinuxHashes."dylint-link-${platformSuffix}";
  };

  upstreamLinux = stdenv.mkDerivation {
    pname = "dylint";
    inherit version;

    srcs = [
      cargoDylintSrc
      dylintLinkSrc
    ];

    sourceRoot = ".";

    nativeBuildInputs = [ autoPatchelfHook ];
    # The prebuilt binaries link libz.so.1.
    buildInputs = [
      stdenv.cc.cc.lib
      zlib
    ];

    dontBuild = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin

      # Upstream tarballs are flat or wrap the binary in a versioned dir
      # (v6.x): extract to a staging dir and copy the binary out.
      tmpd=$(mktemp -d)
      tar xzf ${cargoDylintSrc} -C "$tmpd"
      install -m 755 "$(find "$tmpd" -type f -name cargo-dylint)" $out/bin/cargo-dylint

      rm -rf "$tmpd"
      tmpd=$(mktemp -d)
      tar xzf ${dylintLinkSrc} -C "$tmpd"
      install -m 755 "$(find "$tmpd" -type f -name dylint-link)" $out/bin/dylint-link

      runHook postInstall
    '';

    doInstallCheck = true;
    # cargo-dylint is a rustup-style proxy and refuses to run without
    # RUSTUP_TOOLCHAIN; any value is fine for --help.
    installCheckPhase = ''
      runHook preInstallCheck
      RUSTUP_TOOLCHAIN=stable $out/bin/cargo-dylint --help > /dev/null
      RUSTUP_TOOLCHAIN=stable $out/bin/dylint-link --help > /dev/null
      runHook postInstallCheck
    '';

    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };
in
if hasUpstreamBinary then upstreamLinux else sourceBuild
