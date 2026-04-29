# Rust Pre-built Binaries Plan

## Summary

Switch Rust packages from building from source to using pre-built GitHub release binaries. This eliminates slow Rust compilation times.

## Phase 1: Complete ✅

Switched packages with existing upstream releases:

| Package           | Repo                 | Version | Platforms    | Status          |
| ----------------- | -------------------- | ------- | ------------ | --------------- |
| **knope**         | knope-dev/knope      | 0.22.4  | 4 platforms  | ✅ Done         |
| **wait-for-them** | shenek/wait-for-them | 0.5.1   | macos, linux | ✅ Done         |
| **kani**          | model-checking/kani  | 0.67.0  | 4 platforms  | ✅ Already done |

## Phase 2: Self-hosted Binaries

### Packages Without Pre-built Binaries

| Package                      | Repo                             | Current Version | Notes                               |
| ---------------------------- | -------------------------------- | --------------- | ----------------------------------- |
| **dylint**                   | trailofbits/dylint               | 5.0.0           | Builds cargo-dylint and dylint-link |
| **pina**                     | pina-rs/pina                     | 0.8.0           | Solana smart contract CLI           |
| **cargo-clean-all**          | dnlmlr/cargo-clean-all           | 0.6.4           | Cargo utility                       |
| **cargo-interactive-update** | benjeau/cargo-interactive-update | 0.6.2           | Cargo utility                       |
| **sbpf-linker**              | blueshift-gg/sbpf-linker         | 0.1.8           | Needs LLVM 22, custom features      |

### Implementation

Created `.github/workflows/build-rust-prebuilt.yml` that:

1. **Triggered manually** via `workflow_dispatch` with package name and version
2. **Builds for 4 platforms**:
   - `aarch64-apple-darwin` (macOS ARM)
   - `x86_64-apple-darwin` (macOS Intel)
   - `aarch64-unknown-linux-gnu` (Linux ARM)
   - `x86_64-unknown-linux-gnu` (Linux x86)
3. **Uses `taiki-e/upload-rust-binary-action`** for consistent builds
4. **Creates a release** with tag pattern `prebuilt/<package>/<version>`
5. **Uploads binaries** with SHA256 checksums

### How to Use

#### Step 1: Trigger the workflow

```bash
# Via GitHub CLI
gh workflow run build-rust-prebuilt.yml \
  -f package=dylint \
  -f version=5.0.0

# Or via GitHub UI:
# Actions → Build Rust Prebuilt Binary → Run workflow
```

#### Step 2: Wait for completion

The workflow will:

- Build binaries for all 4 platforms
- Create a release at `prebuilt/<package>/<version>`
- Upload `.tar.gz` archives with SHA256 checksums

#### Step 3: Get the hashes

After the release is created, download the hashes:

```bash
# Example for dylint
gh release view prebuilt/dylint/5.0.0 --json assets | jq -r '.assets[] | "\(.name) \(.digest)"'
```

Or download each binary and calculate:

```bash
nix hash to-sri --type sha256 $(nix-prefetch-url --unpack "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/dylint/5.0.0/dylint-aarch64-apple-darwin.tar.gz")
```

#### Step 4: Update the package.nix

Convert from `rustPlatform.buildRustPackage` to `stdenv.mkDerivation` with prebuilt binaries:

```nix
{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "5.0.0";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    "x86_64-apple-darwin" = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=";
    "aarch64-unknown-linux-gnu" = "sha256-CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC=";
    "x86_64-unknown-linux-gnu" = "sha256-DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD=";
  };
in
stdenv.mkDerivation {
  pname = "dylint";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/dylint/${version}/dylint-${platformSuffix}.tar.gz";
    hash = hashes.${platformSuffix} or lib.fakeHash;
  };

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -R ./* $out/bin/
    chmod +x $out/bin/*

    runHook postInstall
  '';

  meta = {
    description = "Dylint tools for running Rust lints";
    homepage = "https://github.com/trailofbits/dylint";
    license = [ lib.licenses.asl20 lib.licenses.mit ];
    mainProgram = "cargo-dylint";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [ "cli" "dev-tool" "rust" ];
  };
}
```

### Package-specific Notes

#### dylint

- Builds two binaries: `cargo-dylint` and `dylint-link`
- Needs OpenSSL, libgit2, zlib
- May need to adjust `archive` pattern for multiple binaries

#### pina

- Simple build, no special dependencies
- Binary is in `crates/pina_cli`

#### cargo-clean-all

- Simple build, no special dependencies

#### cargo-interactive-update

- Needs `curl` (via pkg-config)

#### sbpf-linker

- Needs LLVM 22
- Build with `--features upstream-gallery-22 --no-default-features`
- May need special handling for LLVM paths

### Future Improvements

1. **Automated updates**: Create a workflow that checks for new versions and triggers builds automatically
2. **Cache sharing**: Use GitHub Actions cache to speed up builds
3. **Cross-compilation**: Use `cross` tool for more reliable cross-compilation
4. **Matrix optimization**: Skip builds for platforms where upstream already provides binaries

## Build Time Comparison

| Package                  | Source Build | Prebuilt | Savings |
| ------------------------ | ------------ | -------- | ------- |
| knope                    | ~5 min       | ~7 sec   | 98%     |
| wait-for-them            | ~3 min       | ~6 sec   | 97%     |
| dylint                   | ~8 min       | ~7 sec   | 99%     |
| pina                     | ~4 min       | ~7 sec   | 97%     |
| cargo-clean-all          | ~3 min       | ~6 sec   | 97%     |
| cargo-interactive-update | ~3 min       | ~6 sec   | 97%     |
| sbpf-linker              | ~10 min      | ~7 sec   | 99%     |
