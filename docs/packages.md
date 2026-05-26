# packages

This flake exposes packages through both `packages.${system}` and `overlays.default`.

## catalog

| Package                                                                                                      | Platforms              | Notes                                                        |
| ------------------------------------------------------------------------------------------------------------ | ---------------------- | ------------------------------------------------------------ |
| `agave`, `solana`, `agave-4_0`, `agave-3_1`, `agave-3_0`, `agave-2_3`, `agave-2_2`, `agave-2_1`, `agave-2_0` | linux x64, macOS       | Agave/Solana validator client and CLI tracks                 |
| `cargo-clean-all`                                                                                            | linux, macOS           | Recursively clean Cargo project targets                      |
| `cargo-interactive-update`                                                                                   | linux, macOS           | Interactively update Cargo dependencies                      |
| `codex-cli`                                                                                                  | linux, macOS           | OpenAI Codex CLI                                             |
| `deno`                                                                                                       | linux, macOS           | Deno runtime from pre-built releases (with SHA-256SUMS verification) |
| `dylint`                                                                                                     | linux, macOS           | Rust lint tooling                                            |
| `godot`                                                                                                      | linux, macOS           | Godot editor/launcher from upstream binaries                 |
| `gpg-suite`                                                                                                  | macOS                  | GPG Suite app bundle                                         |
| `herdr`                                                                                                      | linux, macOS           | Terminal agent multiplexer                                   |
| `ironclaw`                                                                                                   | linux, macOS           | NEAR AI Agent OS                                             |
| `kani`                                                                                                       | linux, macOS           | Rust model checker                                           |
| `keyring`                                                                                                    | linux, macOS           | Rust Keyring CLI; repo-hosted prebuilts with source fallback |
| `knope`                                                                                                      | linux, macOS           | Release/changelog/version automation                         |
| `mdt`                                                                                                        | linux, macOS           | Markdown templating updater                                  |
| `monochange`                                                                                                 | linux, macOS           | Monorepo version and release manager                         |
| `nordvpn`                                                                                                    | macOS                  | NordVPN client                                               |
| `ollama`                                                                                                     | linux, macOS           | Local LLM CLI/app                                            |
| `op`                                                                                                         | linux, macOS           | 1Password CLI beta channel                                   |
| `pina`                                                                                                       | linux, macOS           | Solana smart contract framework CLI                          |
| `pnpm`, `pnpm-11`, `pnpm-10`, `pnpm-standalone`                                                              | linux, macOS           | Standalone pnpm tracks and compatibility alias               |
| `racket-minimal`                                                                                             | linux, macOS           | Minimal Racket distribution                                  |
| `sbpf-linker`                                                                                                | macOS                  | SBPF linker                                                  |
| `secretspec`                                                                                                 | linux, macOS           | Declarative secrets CLI                                      |
| `solana-verify`                                                                                              | linux x64, macOS arm64 | Verifiable Solana builds                                     |
| `steam`                                                                                                      | macOS                  | Steam app bundle                                             |
| `surfpool`                                                                                                   | linux x64, macOS       | Solana test-validator replacement                            |
| `wait-for-them`                                                                                              | linux x64, macOS x64   | TCP/HTTP readiness helper                                    |
| `zoom`                                                                                                       | macOS                  | Zoom client                                                  |

## usage

Run a package directly:

```bash
nix run github:ifiokjr/nixpkgs#secretspec -- --version
nix run github:ifiokjr/nixpkgs#herdr -- --version
nix run github:ifiokjr/nixpkgs#pnpm -- --version
```

Use from another flake:

```nix
let
  extra = inputs.ifiokjr-nixpkgs.packages.${system};
in {
  environment.systemPackages = [
    extra.herdr
    extra.ironclaw
    extra.keyring
    extra.op
    extra.pnpm
    extra.secretspec
  ];
}
```

## pnpm tracks

- `pnpm` tracks the latest standalone pnpm release.
- `pnpm-11` tracks the latest v11 release and uses `pnpm runtime set node` in `pnpm-activate-env`.
- `pnpm-10` tracks the latest v10 release and uses `pnpm env add --global` in `pnpm-activate-env`.
- `pnpm-standalone` is a compatibility alias for `pnpm`.
