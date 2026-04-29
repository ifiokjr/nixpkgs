# Rust Pre-built Binaries Plan

## Summary

Switch Rust packages from building from source to using pre-built GitHub release binaries. This eliminates slow Rust compilation times.

## Package Analysis

### ✅ Can Switch to Pre-built (2 packages)

| Package           | Repo                 | Version | Platforms Available                                                  |
| ----------------- | -------------------- | ------- | -------------------------------------------------------------------- |
| **knope**         | knope-dev/knope      | 0.22.4  | aarch64-darwin, x86_64-darwin, aarch64-linux-musl, x86_64-linux-musl |
| **wait-for-them** | shenek/wait-for-them | 0.5.1   | macos, linux (no arch distinction - likely x86_64)                   |

### ✅ Already Using Pre-built (1 package)

| Package  | Repo                | Version |
| -------- | ------------------- | ------- |
| **kani** | model-checking/kani | 0.67.0  |

### ❌ No Pre-built Binaries Available (5 packages)

| Package                      | Repo                             | Version | Notes                              |
| ---------------------------- | -------------------------------- | ------- | ---------------------------------- |
| **dylint**                   | trailofbits/dylint               | 5.0.0   | Has releases, no binaries attached |
| **pina**                     | pina-rs/pina                     | 0.8.0   | Has releases, no binaries attached |
| **cargo-clean-all**          | dnlmlr/cargo-clean-all           | 0.6.4   | Has releases, no binaries attached |
| **cargo-interactive-update** | benjeau/cargo-interactive-update | 0.6.2   | Has releases, no binaries attached |
| **sbpf-linker**              | blueshift-gg/sbpf-linker         | 0.1.8   | No releases at all                 |

## Phase 1: Switch Available Packages

Convert knope and wait-for-them to use pre-built binaries following the kani pattern.

## Phase 2: Self-hosted Binaries (Future)

For packages without pre-built binaries, we could:

1. **Build binaries in CI** - Create a GitHub Actions workflow that:
   - Builds each Rust package for darwin-aarch64, darwin-x86_64, linux-aarch64, linux-x86_64
   - Creates a release tag (e.g., `prebuilt/<package>/<version>`)
   - Attaches binaries to the release

2. **Use in Nix** - Reference these self-hosted binaries in the package definitions

### Proposed CI Workflow

```yaml
# .github/workflows/build-rust-prebuilt.yml
name: Build Rust Prebuilt Binaries

on:
  workflow_dispatch:
    inputs:
      package:
        description: 'Package to build'
        required: true
        type: choice
        options:
          - dylint
          - pina
          - cargo-clean-all
          - cargo-interactive-update
          - sbpf-linker
      version:
        description: 'Version to build'
        required: true

jobs:
  build:
    strategy:
      matrix:
        include:
          - os: macos-latest
            target: aarch64-apple-darwin
          - os: macos-latest
            target: x86_64-apple-darwin
          - os: ubuntu-latest
            target: aarch64-unknown-linux-gnu
          - os: ubuntu-latest
            target: x86_64-unknown-linux-gnu
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
        with:
          targets: ${{ matrix.target }}
      - name: Build
        run: cargo build --release --target ${{ matrix.target }}
      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: binary-${{ matrix.target }}
          path: target/${{ matrix.target }}/release/*

  release:
    needs: build
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - name: Download artifacts
        uses: actions/download-artifact@v4
      - name: Create release
        uses: softprops/action-gh-release@v1
        with:
          tag_name: prebuilt/${{ inputs.package }}/${{ inputs.version }}
          files: binary-*/*
```

## Implementation

### knope (new pattern)

```nix
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
    "aarch64-apple-darwin" = ""; # TODO: fill
    "x86_64-apple-darwin" = ""; # TODO: fill
    "aarch64-unknown-linux-musl" = ""; # TODO: fill
    "x86_64-unknown-linux-musl" = ""; # TODO: fill
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
```
