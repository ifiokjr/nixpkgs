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
  version = "6.3.1";
  tag = "v${version}";

  # Rust target triple for the host platform, e.g. aarch64-apple-darwin.
  platformSuffix = stdenv.hostPlatform.rust.rustcTarget;

  # Linux prebuilt hashes from upstream releases
  upstreamLinuxHashes = {
    "cargo-dylint-aarch64-unknown-linux-gnu" = "sha256-tyOaJ6VL5ErB8TlzC0QHkL6Vp7B/qyBESEyZlofKNsg=";
    "dylint-link-aarch64-unknown-linux-gnu" = "sha256-bDvYeFfG0qs/TOjAg0Wx9BqXA9Pit8g3W/Lo5PZiSII=";
    "cargo-dylint-x86_64-unknown-linux-gnu" = "sha256-5eoWQyRIGCADyxPzLVFpK534NdCjnT9AL3UGQKOxTXg=";
    "dylint-link-x86_64-unknown-linux-gnu" = "sha256-ImwxXIPoBnlfSOi+g0FZW2WdPRaIOitaK+EDz9qN/K0=";
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
    hash = "sha256-4JctOUE42cIXhCwU43T6i/SKyvzQjNJZfCVlFkXC1Mk=";
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
