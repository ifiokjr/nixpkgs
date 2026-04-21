# nixpkgs

[![CI](https://github.com/ifiokjr/nixpkgs/actions/workflows/ci.yml/badge.svg)](https://github.com/ifiokjr/nixpkgs/actions/workflows/ci.yml) [![Nix Flake](https://img.shields.io/badge/nix-flake-blue?logo=nixos)](https://nixos.wiki/wiki/Flakes) [![License](https://img.shields.io/github/license/ifiokjr/nixpkgs)](https://github.com/ifiokjr/nixpkgs/blob/main/LICENSE)

Additional Nix packages not yet available in [nixpkgs](https://github.com/NixOS/nixpkgs). Includes macOS GUI applications, standalone CLI tools, and Rust crates built from source.

## packages

| Package                                               | Version                                                                                                              | Platforms                | Description                                                                   |
| ----------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------------------------ | ----------------------------------------------------------------------------- |
| [agave](#agave)                                       | <!-- {~v_agave:"{{ v.agave }}"} -->3.1.13<!-- {/v_agave} -->                                                         | linux (x64), macos       | Solana validator client and CLI toolchain by Anza (latest 3.1.x track)        |
| [agave-3_1](#agave)                                   | <!-- {~v_agave_3_1:"{{ v.agave }}"} -->3.1.13<!-- {/v_agave_3_1} -->                                                 | linux (x64), macos       | Agave pinned to the latest 3.1.x release                                      |
| [agave-3_0](#agave)                                   | <!-- {~v_agave_3_0:"{{ v.agave_3_0 }}"} -->3.0.14<!-- {/v_agave_3_0} -->                                             | linux (x64), macos       | Agave pinned to the latest 3.0.x release                                      |
| [agave-2_3](#agave)                                   | <!-- {~v_agave_2_3:"{{ v.agave_2_3 }}"} -->2.3.13<!-- {/v_agave_2_3} -->                                             | linux (x64), macos       | Agave pinned to the latest 2.3.x release                                      |
| [agave-2_2](#agave)                                   | <!-- {~v_agave_2_2:"{{ v.agave_2_2 }}"} -->2.2.20<!-- {/v_agave_2_2} -->                                             | linux (x64), macos       | Agave pinned to the latest 2.2.x release                                      |
| [agave-2_1](#agave)                                   | <!-- {~v_agave_2_1:"{{ v.agave_2_1 }}"} -->2.1.21<!-- {/v_agave_2_1} -->                                             | linux (x64), macos       | Agave pinned to the latest 2.1.x release                                      |
| [agave-2_0](#agave)                                   | <!-- {~v_agave_2_0:"{{ v.agave_2_0 }}"} -->2.0.25<!-- {/v_agave_2_0} -->                                             | linux (x64), macos       | Agave pinned to the latest 2.0.x release                                      |
| [cargo-interactive-update](#cargo-interactive-update) | <!-- {~v_cargo_interactive_update:"{{ v.cargo_interactive_update }}"} -->0.6.2<!-- {/v_cargo_interactive_update} --> | linux, macos             | A cargo extension to update direct dependencies interactively                 |
| [codex-cli](#codex-cli)                               | <!-- {~v_codex_cli:"{{ v.codex_cli }}"} -->0.122.0<!-- {/v_codex_cli} -->                                            | linux, macos             | OpenAI Codex CLI - AI coding assistant for the terminal                       |
| [codexbar](#codexbar)                                 | <!-- {~v_codexbar:"{{ v.codexbar }}"} -->0.17.0<!-- {/v_codexbar} -->                                                | macos                    | macOS menu bar app showing AI coding tool usage and limits                    |
| [cursor-cli](#cursor-cli)                             | <!-- {~v_cursor_cli:"{{ v.cursor_cli }}"} -->2026.04.17-787b533<!-- {/v_cursor_cli} -->                              | linux, macos             | Cursor AI CLI agent for terminal-based development                            |
| [godot](#godot)                                       | <!-- {~v_godot:"{{ v.godot }}"} -->4.6.2-stable<!-- {/v_godot} -->                                                   | linux, macos             | Free and open-source 2D and 3D game engine                                    |
| [gpg-suite](#gpg-suite)                               | <!-- {~v_gpg_suite:"{{ v.gpg_suite }}"} -->2023.3<!-- {/v_gpg_suite} -->                                             | macos                    | GPG Suite - encryption, signing, and key management                           |
| [knope](#knope)                                       | <!-- {~v_knope:"{{ v.knope }}"} -->0.22.4<!-- {/v_knope} -->                                                         | linux, macos             | Automate common development tasks (changelogs, releases, versioning)          |
| [mdt](#mdt)                                           | <!-- {~v_mdt:"{{ v.mdt }}"} -->0.7.0<!-- {/v_mdt} -->                                                                | linux, macos             | Update markdown content anywhere using comments as template tags              |
| [nordvpn](#nordvpn)                                   | <!-- {~v_nordvpn:"{{ v.nordvpn }}"} -->10.0.4<!-- {/v_nordvpn} -->                                                   | macos                    | NordVPN macOS client                                                          |
| [ollama](#ollama)                                     | <!-- {~v_ollama:"{{ v.ollama }}"} -->0.21.0<!-- {/v_ollama} -->                                                      | linux, macos             | Run local LLMs with Ollama via CLI and desktop app                            |
| [pina](#pina)                                         | <!-- {~v_pina:"{{ v.pina }}"} -->0.8.0<!-- {/v_pina} -->                                                             | linux, macos             | CLI for Pina, a performant Solana smart contract framework                    |
| [pnpm-standalone](#pnpm-standalone)                   | <!-- {~v_pnpm_standalone:"{{ v.pnpm_standalone }}"} -->10.33.0<!-- {/v_pnpm_standalone} -->                          | linux, macos             | Fast, disk-space efficient package manager (no Node.js dependency)            |
| [racket-minimal](#racket-minimal)                     | <!-- {~v_racket_minimal:"{{ v.racket_minimal }}"} -->9.1<!-- {/v_racket_minimal} -->                                 | linux, macos             | Racket programming language (minimal distribution, pre-built)                 |
| [steam](#steam)                                       | <!-- {~v_steam:"{{ v.steam }}"} -->4.0<!-- {/v_steam} -->                                                            | macos                    | Steam video game digital distribution service                                 |
| [surfpool](#surfpool)                                 | <!-- {~v_surfpool:"{{ v.surfpool }}"} -->1.1.2<!-- {/v_surfpool} -->                                                 | linux (x64), macos       | A drop-in replacement for solana-test-validator with mainnet state simulation |
| [wait-for-them](#wait-for-them)                       | <!-- {~v_wait_for_them:"{{ v.wait_for_them }}"} -->0.5.1<!-- {/v_wait_for_them} -->                                  | linux (x64), macos (x64) | Wait for TCP/HTTP endpoints to be ready before proceeding                     |
| [zoom](#zoom)                                         | <!-- {~v_zoom:"{{ v.zoom }}"} -->7.0.0.77593<!-- {/v_zoom} -->                                                       | macos                    | Zoom video conferencing client                                                |

## usage

### run a package directly

```bash
nix run github:ifiokjr/nixpkgs#knope
nix run github:ifiokjr/nixpkgs#mdt
nix run github:ifiokjr/nixpkgs#pnpm-standalone
nix run github:ifiokjr/nixpkgs#codex-cli
nix run github:ifiokjr/nixpkgs#godot
nix run github:ifiokjr/nixpkgs#ollama
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
- **Tracks:**
  - `agave` (latest 3.1.x)
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

### ollama

Ollama for running local LLMs. On macOS this installs `Ollama.app` plus the bundled `ollama` CLI. On Linux it installs the official upstream release bundle and provides `ollama` plus an `ollama-app` launcher alias for `nix run` and desktop-style usage.

- **Binary:** `ollama`, `ollama-app`
- **License:** MIT
- **Source:** <https://github.com/ollama/ollama>
- **Homepage:** <https://ollama.com/>

### pina

CLI for Pina, a performant Solana smart contract framework. Built from source using `rustPlatform.buildRustPackage`.

- **Binary:** `pina`
- **License:** Apache-2.0
- **Source:** <https://github.com/pina-rs/pina>
- **Homepage:** <https://pina.rs>

### pnpm-standalone

Standalone pnpm binary with no Node.js dependency. Downloaded directly from GitHub releases. Includes `pnpm-activate-env` to read `useNodeVersion` from `pnpm-workspace.yaml`, install that Node.js version with `pnpm env add --global`, and emit PATH export commands.

- **Binary:** `pnpm`, `pnpm-activate-env`
- **Activate workspace Node version:** `eval "$(pnpm-activate-env)"`
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

- GitHub release packages (version + platform hashes)
- Homebrew-cask packages (`gpg-suite`, `nordvpn`, `zoom`)
- Rolling URL packages (`steam`)
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
