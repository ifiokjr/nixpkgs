# nixpkgs

[![CI](https://github.com/ifiokjr/nixpkgs/actions/workflows/ci.yml/badge.svg)](https://github.com/ifiokjr/nixpkgs/actions/workflows/ci.yml)
[![Nix Flake](https://img.shields.io/badge/nix-flake-blue?logo=nixos)](https://nixos.wiki/wiki/Flakes)
[![License](https://img.shields.io/github/license/ifiokjr/nixpkgs)](https://github.com/ifiokjr/nixpkgs/blob/main/LICENSE)

Additional Nix packages not yet available in [nixpkgs](https://github.com/NixOS/nixpkgs). Includes macOS GUI applications, standalone CLI tools, and Rust crates built from source.

## packages

| Package                                               | Version    | Platforms          | Description                                                                   |
| ----------------------------------------------------- | ---------- | ------------------ | ----------------------------------------------------------------------------- |
| [agave](#agave)                                       | 3.1.8      | linux (x64), macos | Solana validator client and CLI toolchain by Anza                             |
| [cargo-interactive-update](#cargo-interactive-update) | 0.6.2      | linux, macos       | A cargo extension to update direct dependencies interactively                 |
| [codex-cli](#codex-cli)                               | 0.106.0    | linux, macos       | OpenAI Codex CLI - AI coding assistant for the terminal                       |
| [codexbar](#codexbar)                                 | 0.17.0     | macos              | macOS menu bar app showing AI coding tool usage and limits                    |
| [cursor-cli](#cursor-cli)                             | 2026.02.27 | linux, macos       | Cursor AI CLI agent for terminal-based development                            |
| [google-chrome](#google-chrome)                       | latest     | linux (x64), macos | Google Chrome web browser                                                     |
| [google-drive](#google-drive)                         | latest     | macos              | Google Drive desktop client for macOS                                         |
| [gpg-suite](#gpg-suite)                               | 2023.3     | macos              | GPG Suite - encryption, signing, and key management                           |
| [knope](#knope)                                       | 0.22.3     | linux, macos       | Automate common development tasks (changelogs, releases, versioning)          |
| [mdt](#mdt)                                           | 0.6.0      | linux, macos       | Update markdown content anywhere using comments as template tags              |
| [nordvpn](#nordvpn)                                   | 9.14.0     | macos              | NordVPN macOS client                                                          |
| [pina](#pina)                                         | 0.6.0      | linux, macos       | CLI for Pina, a performant Solana smart contract framework                    |
| [pnpm-standalone](#pnpm-standalone)                   | 10.30.3    | linux, macos       | Fast, disk-space efficient package manager (no Node.js dependency)            |
| [racket-minimal](#racket-minimal)                     | 9.1        | linux, macos       | Racket programming language (minimal distribution, pre-built)                 |
| [steam](#steam)                                       | 4.0        | macos              | Steam video game digital distribution service                                 |
| [surfpool](#surfpool)                                 | 1.0.1      | linux (x64), macos | A drop-in replacement for solana-test-validator with mainnet state simulation |
| [zoom](#zoom)                                         | 6.7.6      | macos              | Zoom video conferencing client                                                |

## usage

### run a package directly

```bash
nix run github:ifiokjr/nixpkgs#knope
nix run github:ifiokjr/nixpkgs#mdt
nix run github:ifiokjr/nixpkgs#pnpm-standalone
nix run github:ifiokjr/nixpkgs#codex-cli
```

### add to your flake

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    ifiokjr-nixpkgs.url = "github:ifiokjr/nixpkgs";
  };

  outputs = { self, nixpkgs, ifiokjr-nixpkgs, ... }:
    let
      system = "aarch64-darwin"; # or "x86_64-linux", etc.
      pkgs = nixpkgs.legacyPackages.${system};
      extra = ifiokjr-nixpkgs.packages.${system};
    in
    {
      # Use individual packages
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          extra.knope
          extra.mdt
          extra.pnpm-standalone
          extra.codex-cli
          extra.cursor-cli
        ];
      };
    };
}
```

### use the overlay

The overlay adds all packages into your nixpkgs set so you can reference them as `pkgs.<name>`.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    ifiokjr-nixpkgs.url = "github:ifiokjr/nixpkgs";
  };

  outputs = { self, nixpkgs, ifiokjr-nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ ifiokjr-nixpkgs.overlays.default ];
      };
    in
    {
      # All packages are now available as pkgs.<name>
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.knope
          pkgs.mdt
          pkgs.pnpm-standalone
        ];
      };
    };
}
```

### add to devenv

In your `devenv.yaml`, add the flake as an input:

```yaml
inputs:
  ifiokjr-nixpkgs:
    url: github:ifiokjr/nixpkgs
```

Then use it in `devenv.nix`:

```nix
{ pkgs, inputs, ... }:

let
  extra = inputs.ifiokjr-nixpkgs.packages.${pkgs.stdenv.system};
in
{
  packages = [
    extra.knope
    extra.mdt
    extra.pnpm-standalone
  ];
}
```

### add to nix-darwin

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:LnL7/nix-darwin";
    ifiokjr-nixpkgs.url = "github:ifiokjr/nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, ifiokjr-nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      extra = ifiokjr-nixpkgs.packages.${system};
    in
    {
      darwinConfigurations.default = darwin.lib.darwinSystem {
        inherit system;
        modules = [
          {
            environment.systemPackages = [
              extra.google-chrome
              extra.google-drive
              extra.gpg-suite
              extra.nordvpn
              extra.steam
              extra.zoom
              extra.knope
              extra.codex-cli
            ];
          }
        ];
      };
    };
}
```

### add to home-manager

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    ifiokjr-nixpkgs.url = "github:ifiokjr/nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ifiokjr-nixpkgs, ... }:
    let
      system = "x86_64-linux";
      extra = ifiokjr-nixpkgs.packages.${system};
    in
    {
      homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          {
            home.packages = [
              extra.knope
              extra.mdt
              extra.pnpm-standalone
              extra.codex-cli
              extra.racket-minimal
            ];
          }
        ];
      };
    };
}
```

## package details

### agave

Solana validator client and CLI toolchain by Anza. Pre-built binary from GitHub releases.

- **Binary:** `solana`
- **License:** Apache-2.0
- **Source:** <https://github.com/anza-xyz/agave>

### cargo-interactive-update

A cargo extension to update direct dependencies interactively. Built from source using `rustPlatform.buildRustPackage`.

- **Binary:** `cargo-interactive-update`
- **License:** MIT
- **Source:** <https://github.com/benjeau/cargo-interactive-update>

### codex-cli

OpenAI Codex CLI for AI-assisted coding directly from the terminal. Pre-built binary from GitHub releases.

- **Binary:** `codex`
- **License:** Apache-2.0
- **Source:** <https://github.com/openai/codex>

### codexbar

macOS menu bar app showing AI coding tool usage and limits. Pre-built `.app` bundle from GitHub releases.

- **License:** MIT
- **Source:** <https://github.com/steipete/CodexBar>
- **Homepage:** <https://codexbar.app>

### cursor-cli

Cursor AI CLI agent for terminal-based AI development workflows. Pre-built binary from Cursor's CDN.

- **Binary:** `cursor-agent`
- **License:** Proprietary
- **Source:** <https://cursor.com/cli>

### google-chrome

Google Chrome web browser. On macOS, installs the `.app` bundle from the universal DMG. On Linux (x64), installs from the official `.deb` with all runtime libraries patched.

- **Binary:** `google-chrome-stable` (Linux)
- **License:** Proprietary
- **Source:** <https://www.google.com/chrome/>

### google-drive

Google Drive desktop client for macOS. Installs the `.app` bundle from the official DMG/PKG.

- **License:** Proprietary
- **Source:** <https://www.google.com/drive/>

### gpg-suite

GPG Suite for macOS providing encryption, signing, and key management. Includes GPG Keychain, GPG Mail, and other tools.

- **License:** GPL-3.0
- **Source:** <https://gpgtools.org/>

### knope

A developer workflow automation tool. Automates changelogs, releases, and versioning based on conventional commits. Built from source using `rustPlatform.buildRustPackage`.

- **Binary:** `knope`
- **License:** MIT
- **Source:** <https://github.com/knope-dev/knope>
- **Homepage:** <https://knope.tech>

### mdt

CLI tool that updates markdown content anywhere using comments as template tags. Built from source using `rustPlatform.buildRustPackage`.

- **Binary:** `mdt`
- **License:** Unlicense
- **Source:** <https://github.com/ifiokjr/mdt>

### nordvpn

NordVPN macOS client. Installs the `.app` bundle from the official PKG.

- **License:** Proprietary
- **Source:** <https://nordvpn.com/>

### pina

CLI for Pina, a performant Solana smart contract framework. Built from source using `rustPlatform.buildRustPackage`.

- **Binary:** `pina`
- **License:** Apache-2.0
- **Source:** <https://github.com/pina-rs/pina>
- **Homepage:** <https://pina.rs>

### pnpm-standalone

Standalone pnpm binary with no Node.js dependency. Downloaded directly from GitHub releases.

- **Binary:** `pnpm`
- **License:** MIT
- **Source:** <https://github.com/pnpm/pnpm>
- **Homepage:** <https://pnpm.io/>

### racket-minimal

Minimal Racket distribution using official pre-built binaries. The upstream `racket-minimal` fails to build from source on macOS due to Nix sandbox restrictions on `AC_RUN_IFELSE` checks.

- **Binary:** `racket`, `raco`
- **License:** Apache-2.0, MIT
- **Source:** <https://racket-lang.org/>

### steam

Steam video game digital distribution service for macOS.

- **License:** Proprietary
- **Source:** <https://store.steampowered.com/>

### surfpool

A drop-in replacement for solana-test-validator with mainnet state simulation. Pre-built binary from GitHub releases.

- **Binary:** `surfpool`
- **License:** Apache-2.0
- **Source:** <https://github.com/txtx/surfpool>

### zoom

Zoom video conferencing client for macOS.

- **License:** Proprietary
- **Source:** <https://zoom.us/>

## updating packages

Run the repo updater to check every package for new upstream releases and refresh all hashes:

```bash
# Preview updates without changing files
./scripts/update --dry-run

# Apply updates in-place
./scripts/update
```

The script updates:

- GitHub release packages (version + platform hashes)
- Homebrew-cask packages (`gpg-suite`, `nordvpn`, `zoom`)
- Rolling URL packages (`google-chrome`, `google-drive`, `steam`)
- Rust packages (`cargo-interactive-update`, `knope`, `mdt`, `pina`) including `cargoHash`

### binary packages (pre-built)

For packages that use pre-built binaries (`fetchurl`), update the version and set the hash to `lib.fakeHash` (or `lib.fakeSha256`):

1. Change the `version` string in `packages/<name>/package.nix`
2. Set hash values to `lib.fakeHash`
3. Run `nix build .#<name>` - Nix will show the correct hash in the error
4. Replace `lib.fakeHash` with the correct hash
5. Build again to verify: `nix build .#<name>`

### rust packages (built from source)

For Rust packages (`knope`, `mdt`), you need to update both the source hash and the cargo hash:

1. Change the `version` string
2. Set both `hash` and `cargoHash` to `lib.fakeHash`
3. Run `nix build .#<name>` - first error gives the source hash
4. Replace the source `hash`, build again - second error gives the cargo hash
5. Replace `cargoHash`, build again to verify

## license

Each package retains its own license. See individual `package.nix` files for details.
