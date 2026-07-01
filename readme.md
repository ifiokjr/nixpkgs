# nixpkgs

[![CI](https://github.com/ifiokjr/nixpkgs/actions/workflows/ci.yml/badge.svg)](https://github.com/ifiokjr/nixpkgs/actions/workflows/ci.yml) [![Nix Flake](https://img.shields.io/badge/nix-flake-blue?logo=nixos)](https://nixos.wiki/wiki/Flakes) [![License](https://img.shields.io/github/license/ifiokjr/nixpkgs)](https://github.com/ifiokjr/nixpkgs/blob/main/LICENSE)

Additional Nix packages not yet available in [nixpkgs](https://github.com/NixOS/nixpkgs). Includes macOS GUI applications, standalone CLI tools, pre-built release packages, and Rust crates built from source.

## packages

| Package                                                                                              | Version                                                                                                              | Platforms                  | Description                                                                      |
| ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | -------------------------- | -------------------------------------------------------------------------------- |
| [agave](#agave)                                                                                      | <!-- {~v_agave:"{{ v.agave_4_0 }}"} -->4.0.3<!-- {/v_agave} -->                                                      | linux (x64), macos         | Solana validator client and CLI toolchain by Anza (mainnet, alias for agave-4_0) |
| [agave-4_0](#agave)                                                                                  | <!-- {~v_agave_4_0:"{{ v.agave_4_0 }}"} -->4.0.3<!-- {/v_agave_4_0} -->                                              | linux (x64), macos         | Agave pinned to the latest 4.0.x release                                         |
| [agave-3_1](#agave)                                                                                  | <!-- {~v_agave_3_1:"{{ v.agave_3_1 }}"} -->3.1.14<!-- {/v_agave_3_1} -->                                             | linux (x64), macos         | Agave pinned to the latest 3.1.x release                                         |
| [agave-3_0](#agave)                                                                                  | <!-- {~v_agave_3_0:"{{ v.agave_3_0 }}"} -->3.0.14<!-- {/v_agave_3_0} -->                                             | linux (x64), macos         | Agave pinned to the latest 3.0.x release                                         |
| [agave-2_3](#agave)                                                                                  | <!-- {~v_agave_2_3:"{{ v.agave_2_3 }}"} -->2.3.13<!-- {/v_agave_2_3} -->                                             | linux (x64), macos         | Agave pinned to the latest 2.3.x release                                         |
| [agave-2_2](#agave)                                                                                  | <!-- {~v_agave_2_2:"{{ v.agave_2_2 }}"} -->2.2.20<!-- {/v_agave_2_2} -->                                             | linux (x64), macos         | Agave pinned to the latest 2.2.x release                                         |
| [agave-2_0](#agave)                                                                                  | <!-- {~v_agave_2_0:"{{ v.agave_2_0 }}"} -->2.0.25<!-- {/v_agave_2_0} -->                                             | linux (x64), macos         | Agave pinned to the latest 2.0.x release                                         |
| [agave-2_1](#agave)                                                                                  | <!-- {~v_agave_2_1:"{{ v.agave_2_1 }}"} -->2.1.21<!-- {/v_agave_2_1} -->                                             | linux (x64), macos         | Agave pinned to the latest 2.1.x release                                         |
| [cargo-clean-all](#cargo-clean-all)                                                                  | <!-- {~v_cargo_clean_all:"{{ v.cargo_clean_all }}"} -->0.6.4<!-- {/v_cargo_clean_all} -->                            | linux, macos               | Recursively clean Cargo projects in a directory that match selected criteria     |
| [cargo-interactive-update](#cargo-interactive-update)                                                | <!-- {~v_cargo_interactive_update:"{{ v.cargo_interactive_update }}"} -->0.6.2<!-- {/v_cargo_interactive_update} --> | linux, macos               | A cargo extension to update direct dependencies interactively                    |
| [codex-cli](#codex-cli)                                                                              | <!-- {~v_codex_cli:"{{ v.codex_cli }}"} -->0.142.4<!-- {/v_codex_cli} -->                                            | linux, macos               | OpenAI Codex CLI - AI coding assistant for the terminal                          |
| [deno](#deno)                                                                                        | <!-- {~v_deno:"{{ v.deno }}"} -->2.9.0<!-- {/v_deno} -->                                                             | linux, macos               | A modern runtime for JavaScript and TypeScript (with SHA-256SUMS verification)   |
| [flutter-launcher-icons](#flutter_launcher_icons), [flutter_launcher_icons](#flutter_launcher_icons) | <!-- {~v_flutter_launcher_icons:"{{ v.flutter_launcher_icons }}"} -->0.14.4<!-- {/v_flutter_launcher_icons} -->      | linux, macos               | Generate launcher icons for Flutter apps                                         |
| [flutter-native-splash](#flutter_native_splash), [flutter_native_splash](#flutter_native_splash)     | <!-- {~v_flutter_native_splash:"{{ v.flutter_native_splash }}"} -->2.4.8<!-- {/v_flutter_native_splash} -->          | linux, macos               | Generate native splash screens for Flutter apps                                  |
| [dylint](#dylint)                                                                                    | <!-- {~v_dylint:"{{ v.dylint }}"} -->6.0.1<!-- {/v_dylint} -->                                                       | linux, macos               | Dylint tools for running Rust lints and building Dylint libraries                |
| [godot](#godot)                                                                                      | <!-- {~v_godot:"{{ v.godot }}"} -->4.6.3-stable<!-- {/v_godot} -->                                                   | linux, macos               | Free and open-source 2D and 3D game engine                                       |
| [gpg-suite](#gpg-suite)                                                                              | <!-- {~v_gpg_suite:"{{ v.gpg_suite }}"} -->2023.3<!-- {/v_gpg_suite} -->                                             | macos                      | GPG Suite - encryption, signing, and key management                              |
| [herdr](#herdr)                                                                                      | <!-- {~v_herdr:"{{ v.herdr }}"} -->0.7.1<!-- {/v_herdr} -->                                                          | linux, macos               | Terminal agent multiplexer - tmux for coding agents                              |
| [ironclaw](#ironclaw)                                                                                | <!-- {~v_ironclaw:"{{ v.ironclaw }}"} -->0.29.1<!-- {/v_ironclaw} -->                                                | linux, macos               | Agent OS focused on privacy, security, and extensibility (NEAR AI)               |
| [kani](#kani)                                                                                        | <!-- {~v_kani:"{{ v.kani }}"} -->0.67.0<!-- {/v_kani} -->                                                            | linux, macos               | Bit-precise model checker for Rust                                               |
| [keyring](#keyring)                                                                                  | <!-- {~v_keyring:"{{ v.keyring }}"} -->4.1.2<!-- {/v_keyring} -->                                                    | linux, macos               | Sample code and CLI for the Rust Keyring                                         |
| [knope](#knope)                                                                                      | <!-- {~v_knope:"{{ v.knope }}"} -->0.23.0<!-- {/v_knope} -->                                                         | linux, macos               | Automate common development tasks (changelogs, releases, versioning)             |
| [mdt](#mdt)                                                                                          | <!-- {~v_mdt:"{{ v.mdt }}"} -->0.7.0<!-- {/v_mdt} -->                                                                | linux, macos               | Update markdown content anywhere using comments as template tags                 |
| [melos](#melos), [melos-cli](#melos)                                                                 | <!-- {~v_melos:"{{ v.melos }}"} -->7.8.0<!-- {/v_melos} -->                                                          | linux, macos               | Manage Dart and Flutter monorepos with multiple packages                         |
| [monochange](#monochange)                                                                            | <!-- {~v_monochange:"{{ v.monochange }}"} -->0.8.3<!-- {/v_monochange} -->                                           | linux, macos               | Manage versions and releases for your multiplatform monorepo                     |
| [nordvpn](#nordvpn)                                                                                  | <!-- {~v_nordvpn:"{{ v.nordvpn }}"} -->10.5.1<!-- {/v_nordvpn} -->                                                   | macos                      | NordVPN macOS client                                                             |
| [ollama](#ollama)                                                                                    | <!-- {~v_ollama:"{{ v.ollama }}"} -->0.30.11<!-- {/v_ollama} -->                                                     | linux, macos               | Run local LLMs with Ollama via CLI and desktop app                               |
| [op](#op)                                                                                            | <!-- {~v_op:"{{ v.op }}"} -->2.31.0-beta.01<!-- {/v_op} -->                                                          | linux, macos               | 1Password CLI beta channel with environment support                              |
| [pina](#pina)                                                                                        | <!-- {~v_pina:"{{ v.pina }}"} -->0.8.0<!-- {/v_pina} -->                                                             | linux, macos               | CLI for Pina, a performant Solana smart contract framework                       |
| [pnpm](#pnpm)                                                                                        | <!-- {~v_pnpm:"{{ v.pnpm }}"} -->11.9.0<!-- {/v_pnpm} -->                                                            | linux, macos               | Fast, disk-space efficient package manager (latest standalone track)             |
| [pnpm-10](#pnpm)                                                                                     | <!-- {~v_pnpm_10:"{{ v.pnpm_10 }}"} -->10.34.3<!-- {/v_pnpm_10} -->                                                  | linux, macos               | Standalone pnpm pinned to the latest v10 release track                           |
| [pnpm-11](#pnpm)                                                                                     | <!-- {~v_pnpm_11:"{{ v.pnpm_11 }}"} -->11.9.0<!-- {/v_pnpm_11} -->                                                   | linux, macos               | Standalone pnpm pinned to the latest v11 release track                           |
| [pnpm-standalone](#pnpm)                                                                             | <!-- {~v_pnpm_standalone:"{{ v.pnpm_standalone }}"} --><!-- {/v_pnpm_standalone} -->                                 | linux, macos               | Fast, disk-space efficient package manager (no Node.js dependency)               |
| [racket-minimal](#racket-minimal)                                                                    | <!-- {~v_racket_minimal:"{{ v.racket_minimal }}"} -->9.2<!-- {/v_racket_minimal} -->                                 | linux, macos               | Racket programming language (minimal distribution, pre-built)                    |
| [sbpf-linker](#sbpf-linker)                                                                          | <!-- {~v_sbpf_linker:"{{ v.sbpf_linker }}"} -->0.1.6<!-- {/v_sbpf_linker} -->                                        | macos                      | Upstream BPF linker for SBPF V0 programs                                         |
| [secretspec](#secretspec)                                                                            | <!-- {~v_secretspec:"{{ v.secretspec }}"} -->0.10.1<!-- {/v_secretspec} -->                                          | linux, macos               | Declarative secrets, every environment, any provider                             |
| [solana](#agave)                                                                                     | <!-- {~v_solana:"{{ v.agave_4_0 }}"} -->4.0.3<!-- {/v_solana} -->                                                    | linux (x64), macos         | Alias for agave-4_0 (Solana validator client and CLI for mainnet)                |
| [solana-verify](#solana-verify)                                                                      | <!-- {~v_solana_verify:"{{ v.solana_verify }}"} -->0.5.1<!-- {/v_solana_verify} -->                                  | linux (x64), macos (arm64) | CLI tool for building verifiable Solana programs                                 |
| [serverpod](#serverpod_cli), [serverpod-cli](#serverpod_cli), [serverpod_cli](#serverpod_cli)        | <!-- {~v_serverpod_cli:"{{ v.serverpod_cli }}"} -->3.4.8<!-- {/v_serverpod_cli} -->                                  | linux, macos               | Command line tools for Serverpod                                                 |
| [steam](#steam)                                                                                      | <!-- {~v_steam:"{{ v.steam }}"} -->4.0<!-- {/v_steam} -->                                                            | macos                      | Steam video game digital distribution service                                    |
| [surfpool](#surfpool)                                                                                | <!-- {~v_surfpool:"{{ v.surfpool }}"} -->1.4.0<!-- {/v_surfpool} -->                                                 | linux (x64), macos         | A drop-in replacement for solana-test-validator with mainnet state simulation    |
| [wait-for-them](#wait-for-them)                                                                      | <!-- {~v_wait_for_them:"{{ v.wait_for_them }}"} -->0.5.1<!-- {/v_wait_for_them} -->                                  | linux (x64), macos (x64)   | Wait for TCP/HTTP endpoints to be ready before proceeding                        |
| [zoom](#zoom)                                                                                        | <!-- {~v_zoom:"{{ v.zoom }}"} -->7.1.0.83064<!-- {/v_zoom} -->                                                       | macos                      | Zoom video conferencing client                                                   |

## usage

### run a package directly

```bash
nix run github:ifiokjr/nixpkgs#knope
nix run github:ifiokjr/nixpkgs#mdt
nix run github:ifiokjr/nixpkgs#monochange
nix run github:ifiokjr/nixpkgs#pnpm-standalone
nix run github:ifiokjr/nixpkgs#codex-cli
nix run github:ifiokjr/nixpkgs#deno
nix run github:ifiokjr/nixpkgs#godot
nix run github:ifiokjr/nixpkgs#ollama
nix run github:ifiokjr/nixpkgs#herdr
nix run github:ifiokjr/nixpkgs#ironclaw
nix run github:ifiokjr/nixpkgs#op
nix run github:ifiokjr/nixpkgs#pnpm
nix run github:ifiokjr/nixpkgs#secretspec
nix run github:ifiokjr/nixpkgs#keyring -- --help
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
          extra.monochange
          extra.pnpm-standalone
          extra.codex-cli
          extra.herdr
          extra.ironclaw
          extra.keyring
          extra.op
          extra.pnpm
          extra.secretspec
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
          pkgs.monochange
          pkgs.pnpm-standalone
          pkgs.herdr
          pkgs.ironclaw
          pkgs.keyring
          pkgs.op
          pkgs.pnpm
          pkgs.secretspec
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
    extra.monochange
    extra.pnpm-standalone
    extra.herdr
    extra.ironclaw
    extra.keyring
    extra.op
    extra.pnpm
    extra.secretspec
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
              extra.gpg-suite
              extra.nordvpn
              extra.steam
              extra.zoom
              extra.knope
              extra.codex-cli
              extra.herdr
              extra.ironclaw
              extra.keyring
              extra.op
              extra.pnpm
              extra.secretspec
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
              extra.herdr
              extra.ironclaw
              extra.keyring
              extra.op
              extra.pnpm
              extra.secretspec
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
- **Tracks:**
  - `agave` (mainnet = latest 4.0.x, alias: `solana`)
  - `agave-4_0`
  - `agave-3_1`
  - `agave-3_0`
  - `agave-2_3`
  - `agave-2_2`
  - `agave-2_1`
  - `agave-2_0`

Examples:

```bash
nix run github:ifiokjr/nixpkgs#agave -- --version
nix run github:ifiokjr/nixpkgs#agave-3_0 -- --version
nix run github:ifiokjr/nixpkgs#agave-2_1 -- --version
```

### cargo-clean-all

Recursively clean Cargo projects in a directory based on filters like project age, target size, ignored paths, and interactive selection. Built from source using `rustPlatform.buildRustPackage`.

- **Binary:** `cargo-clean-all`
- **License:** MIT
- **Source:** <https://github.com/dnlmlr/cargo-clean-all>

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

### deno

A modern runtime for JavaScript and TypeScript. Installs the official pre-built binary from Deno GitHub releases instead of building from Rust source.

- **Binary:** `deno`
- **License:** MIT
- **Source:** <https://github.com/denoland/deno>
- **Homepage:** <https://deno.com/>

### dylint

Dylint tools for running Rust lints and building Dylint libraries. Built from source using `rustPlatform.buildRustPackage`.

- **Binary:** `cargo-dylint`, `dylint-link`
- **License:** Apache-2.0 OR MIT
- **Source:** <https://github.com/trailofbits/dylint>

### godot

Free and open-source 2D and 3D game engine. Installs pre-built editor binaries from GitHub releases and provides a `godot` launcher for `nix run`.

- **Binary:** `godot`
- **License:** MIT
- **Source:** <https://github.com/godotengine/godot>
- **Homepage:** <https://godotengine.org/>

### gpg-suite

GPG Suite for macOS providing encryption, signing, and key management. Includes GPG Keychain, GPG Mail, and other tools.

- **License:** GPL-3.0
- **Source:** <https://gpgtools.org/>

### herdr

Terminal agent multiplexer for running and switching between coding agents in tmux sessions. Installs the upstream pre-built release binary.

- **Binary:** `herdr`
- **License:** AGPL-3.0-only
- **Source:** <https://github.com/ogulcancelik/herdr>

### ironclaw

Agent OS focused on privacy, security, and extensibility for NEAR AI workflows. Installs pre-built release binaries.

- **Binary:** `ironclaw`
- **License:** Apache-2.0, MIT
- **Source:** <https://github.com/nearai/ironclaw>

### kani

Bit-precise model checker for Rust. Installs the official upstream release bundle and provides both `kani` and `cargo-kani` commands.

- **Binary:** `kani`, `cargo-kani`
- **License:** Apache-2.0, MIT
- **Source:** <https://github.com/model-checking/kani>
- **Homepage:** <https://model-checking.github.io/kani/>

### keyring

Sample code and CLI for the Rust Keyring crate. Upstream does not publish release binaries, so this package is set up to consume pre-built artifacts produced by this repo's `build-rust-prebuilt.yml` workflow from the upstream `keyring-rs` source tag. Until a prebuilt release exists for a platform, it falls back to a pinned source build with `cargoHash`.

- **Binary:** `keyring`
- **License:** Apache-2.0, MIT
- **Source:** <https://github.com/open-source-cooperative/keyring-rs>
- **Homepage:** <https://github.com/open-source-cooperative/keyring-rs/wiki/Keyring>

### knope

A developer workflow automation tool. Automates changelogs, releases, and versioning based on conventional commits. Built from source using `rustPlatform.buildRustPackage`.

- **Binary:** `knope`
- **License:** MIT
- **Source:** <https://github.com/knope-dev/knope>
- **Homepage:** <https://knope.tech>

### mdt

CLI tool that updates markdown content anywhere using comments as template tags. Pre-built binary from GitHub releases.

- **Binary:** `mdt`
- **License:** Unlicense
- **Source:** <https://github.com/ifiokjr/mdt>

### monochange

Manage versions and releases for your multiplatform, multilanguage monorepo. Pre-built binary from GitHub releases.

- **Binary:** `monochange`, `mc`
- **License:** Unlicense
- **Source:** <https://github.com/ifiokjr/monochange>
- **Homepage:** <https://ifiokjr.github.io/monochange/>

### nordvpn

NordVPN macOS client. Installs the `.app` bundle from the official PKG.

- **License:** Proprietary
- **Source:** <https://nordvpn.com/>

### ollama

Ollama for running local LLMs. On macOS this installs `Ollama.app` plus the bundled `ollama` CLI. On Linux it installs the official upstream release bundle and provides `ollama` plus an `ollama-app` launcher alias for `nix run` and desktop-style usage.

- **Binary:** `ollama`, `ollama-app`
- **License:** MIT
- **Source:** <https://github.com/ollama/ollama>
- **Homepage:** <https://ollama.com/>

### op

1Password CLI beta channel, packaged for access to beta-only `op environment` support. Installs the official upstream pre-built binary.

- **Binary:** `op`
- **License:** Proprietary
- **Source:** <https://developer.1password.com/docs/cli/>

### pina

CLI for Pina, a performant Solana smart contract framework. Built from source using `rustPlatform.buildRustPackage`.

- **Binary:** `pina`
- **License:** Apache-2.0
- **Source:** <https://github.com/pina-rs/pina>
- **Homepage:** <https://pina.rs>

### pnpm

Standalone pnpm binary with no Node.js dependency. Downloaded directly from GitHub releases. `pnpm` tracks the latest release, while `pnpm-11` and `pnpm-10` are explicit versioned tracks. `pnpm-standalone` is kept as a compatibility alias for the latest track. The wrapper sets mutable state defaults for PNPM-managed Node and package stores without writing to the Nix store. Includes `pnpm-activate-env` to read `useNodeVersion` from `pnpm-workspace.yaml`, install that Node.js version with the appropriate pnpm runtime/env command, and emit PATH export commands.

- **Binary:** `pnpm`, `pnpm-activate-env`
- **Packages:** `pnpm`, `pnpm-11`, `pnpm-10`, `pnpm-standalone`
- **Activate workspace Node version:** `eval "$(pnpm-activate-env)"`
- **Mutable state defaults:** sets `PNPM_HOME` when unset (`$XDG_DATA_HOME/pnpm`, `~/Library/pnpm` on macOS, or `~/.local/share/pnpm` on Linux)
- **Store location:** PNPM stores packages and managed Node runtimes under `PNPM_HOME` (for example, `PNPM_HOME/store` and `PNPM_HOME/bin` on v11)
- **Runtime support:** v11 uses `pnpm runtime set node`; v10 uses `pnpm env add --global`
- **License:** MIT
- **Source:** <https://github.com/pnpm/pnpm>
- **Homepage:** <https://pnpm.io/>

Bash auto-activate example (`~/.bashrc`):

```bash
pnpm_auto_activate() {
  eval "$(pnpm-activate-env 2>/dev/null || true)"
}

PROMPT_COMMAND="pnpm_auto_activate${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
pnpm_auto_activate
```

Zsh auto-activate example (`~/.zshrc`):

```zsh
autoload -U add-zsh-hook
pnpm_auto_activate() {
  eval "$(pnpm-activate-env 2>/dev/null || true)"
}

add-zsh-hook chpwd pnpm_auto_activate
pnpm_auto_activate
```

Nushell auto-activate example (`config.nu`):

```nu
def --env pnpm_auto_activate [] {
  let res = (^pnpm-activate-env | complete)

  if $res.exit_code != 0 { return }
  if ($res.stdout | str trim) == "" { return }

  let first = ($res.stdout | lines | first | default "")
  let node_bin = (
    $first
    | parse "__pnpm_activate_node_bin='{bin}'"
    | get 0.bin?
    | default ""
  )

  if $node_bin == "" { return }

  if ($env.PATH | any {|p| $p == $node_bin }) == false {
    $env.PATH = ($env.PATH | prepend $node_bin)
  }
}

$env.config.hooks.env_change.PWD = (
  $env.config.hooks.env_change.PWD?
  | default []
  | append { |before, after| pnpm_auto_activate }
)

pnpm_auto_activate
```

### racket-minimal

Minimal Racket distribution using official pre-built binaries. The upstream `racket-minimal` fails to build from source on macOS due to Nix sandbox restrictions on `AC_RUN_IFELSE` checks.

- **Binary:** `racket`, `raco`
- **License:** Apache-2.0, MIT
- **Source:** <https://racket-lang.org/>

### sbpf-linker

Upstream BPF linker for SBPF V0 programs. Built from source using `rustPlatform.buildRustPackage` with LLVM 22.

- **Binary:** `sbpf-linker`
- **License:** MIT
- **Source:** <https://github.com/blueshift-gg/sbpf-linker>

### secretspec

Declarative secrets tooling for every environment and any provider. Built from the `ifiokjr/secretspec` source branch with keyring support enabled on Linux.

- **Binary:** `secretspec`
- **License:** Apache-2.0
- **Source:** <https://github.com/ifiokjr/secretspec>
- **Homepage:** <https://secretspec.dev>

### solana-verify

CLI tool for building verifiable Solana programs. Installs the upstream `solana-verify` binary from GitHub releases.

- **Binary:** `solana-verify`
- **License:** MIT
- **Source:** <https://github.com/solana-foundation/solana-verifiable-build>

### steam

Steam video game digital distribution service for macOS.

- **License:** Proprietary
- **Source:** <https://store.steampowered.com/>

### surfpool

A drop-in replacement for solana-test-validator with mainnet state simulation. Pre-built binary from GitHub releases.

- **Binary:** `surfpool`
- **License:** Apache-2.0
- **Source:** <https://github.com/txtx/surfpool>

### wait-for-them

Wait until all provided host:port TCP pairs are opened or HTTP/HTTPS URLs return status 200. Useful in docker-compose setups and scripts to wait for dependent services. Pre-built binary from GitHub releases.

- **Binary:** `wait-for-them`
- **License:** GPL-3.0
- **Source:** <https://github.com/shenek/wait-for-them>

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

- GitHub release packages (version + platform hashes, including `herdr`, `ironclaw`, `keyring`, `op`, and `pnpm`)
- Homebrew-cask packages (`gpg-suite`, `nordvpn`, `zoom`)
- Rolling URL packages (`steam`)
- Rust packages built from source (`cargo-clean-all`, `cargo-interactive-update`, `dylint`, `knope`, `pina`, `sbpf-linker`, `secretspec`)

### binary packages (pre-built)

For packages that use pre-built binaries (`fetchurl`), update the version and set the hash to `lib.fakeHash` (or `lib.fakeSha256`):

1. Change the `version` string in `packages/<name>/package.nix`
2. Set hash values to `lib.fakeHash`
3. Run `nix build .#<name>` - Nix will show the correct hash in the error
4. Replace `lib.fakeHash` with the correct hash
5. Build again to verify: `nix build .#<name>`

### rust packages (built from source)

Rust packages in this repo use one of two patterns:

- `cargoHash`: update both the source hash and the cargo hash
- `cargoLock`: update the source hash and keep `Cargo.lock` in sync with upstream

For `cargoHash` packages:

1. Change the `version` string
2. Set both `hash` and `cargoHash` to `lib.fakeHash`
3. Run `nix build .#<name>` - first error gives the source hash
4. Replace the source `hash`, build again - second error gives the cargo hash
5. Replace `cargoHash`, build again to verify

For `cargoLock` packages:

1. Change the `version` string
2. Set `hash` to `lib.fakeHash`
3. Run `nix build .#<name>` - Nix will show the correct source hash
4. Replace `hash`, then build again to verify

## license

Each package retains its own license. See individual `package.nix` files for details.
