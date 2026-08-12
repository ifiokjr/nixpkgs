# serverpod_cli-3

`serverpod_cli` is the command-line tool for [Serverpod](https://serverpod.dev), a Dart and Flutter backend framework.

This is the stable 3.x track and the default — the `serverpod`, `serverpod-cli`, and `serverpod_cli` aliases all resolve here. Use `serverpod_cli-4` for the 4.x beta track.

Use it to create Serverpod projects, generate protocol and serialization code, run migrations, and manage Serverpod application workflows.

## usage

```bash
nix run github:ifiokjr/nixpkgs#serverpod_cli-3 -- --help
# default aliases (resolve to the 3.x track):
nix run github:ifiokjr/nixpkgs#serverpod -- --help
nix run github:ifiokjr/nixpkgs#serverpod-cli -- --help
nix run github:ifiokjr/nixpkgs#serverpod_cli -- --help
```

The installed executable is `serverpod`.

## updates

This package tracks the latest 3.x stable `serverpod_cli` version published to Pub and builds from the matching Serverpod GitHub monorepo tag because the CLI depends on sibling packages in that repository.

Run the repository updater from the repo root:

```bash
./scripts/update
```
