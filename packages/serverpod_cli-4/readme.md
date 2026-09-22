# serverpod_cli-4

`serverpod_cli-4` is the command-line tool for [Serverpod](https://serverpod.dev) 4.x — the current stable track. A Dart and Flutter backend framework.

This is the default: the `serverpod`, `serverpod-cli`, and `serverpod_cli` aliases all resolve here. Use `serverpod_cli-3` for the older 3.x track.

Use it to create Serverpod projects, generate protocol and serialization code, run migrations, and manage Serverpod application workflows.

## usage

```bash
nix run github:ifiokjr/nixpkgs#serverpod_cli-4 -- --help
# default aliases (resolve to the 4.x track):
nix run github:ifiokjr/nixpkgs#serverpod -- --help
nix run github:ifiokjr/nixpkgs#serverpod-cli -- --help
nix run github:ifiokjr/nixpkgs#serverpod_cli -- --help
```

The installed executable is `serverpod`.

## updates

This package tracks the latest stable `serverpod_cli` 4.x version published to Pub and builds from the matching Serverpod GitHub monorepo tag because the CLI depends on sibling packages in that repository.

Run the repository updater from the repo root:

```bash
./scripts/update
```
