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
  version = "6.0.2";
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
    "cargo-dylint-aarch64-unknown-linux-gnu" = "sha256-AXVNGpSJaaPO80KjkjgyoSxrFHgxq2J3IhhlU7FSPwU=";
    "dylint-link-aarch64-unknown-linux-gnu" = "sha256-0fQCHP2cF90g8Gdm8J0vnn+TmZVRBHvcKyAQTyLaiiw=";
    "cargo-dylint-x86_64-unknown-linux-gnu" = "sha256-Q2BNjZTGuYgc0TL93PyVntbtUBDSPduyvx+0YNAMcmU=";
    "dylint-link-x86_64-unknown-linux-gnu" = "sha256-gOPRHyMxl6HNjURIBrFZV39rGfNgLhjJTYnqGMcD7no=";
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
    hash = "sha256-cAN2eXOlWcmhD4co+8Wo7zEfwPnIF+RKoexdvpCRcrc=";
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
    installCheckPhase = "$out/bin/cargo-dylint --help > /dev/null";
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
    buildInputs = [ stdenv.cc.cc.lib ];

    dontBuild = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin

      tar xzf ${cargoDylintSrc} -C $out/bin/
      chmod +x $out/bin/cargo-dylint

      tar xzf ${dylintLinkSrc} -C $out/bin/
      chmod +x $out/bin/dylint-link

      runHook postInstall
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      $out/bin/cargo-dylint --help > /dev/null
      $out/bin/dylint-link --help > /dev/null
      runHook postInstallCheck
    '';

    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };
in
if hasUpstreamBinary then upstreamLinux else sourceBuild
