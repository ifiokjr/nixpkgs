# serverpod_cli-4

`serverpod_cli-4` is the command-line tool for [Serverpod](https://serverpod.dev) 4.x — the beta track following pre-release `4.0.0-beta.*` versions. A Dart and Flutter backend framework.

Use it to create Serverpod projects, generate protocol and serialization code, run migrations, and manage Serverpod application workflows.

For the stable 3.x track, use `serverpod_cli-3` (the default `serverpod` / `serverpod-cli` / `serverpod_cli` aliases resolve to the 3.x track).

## usage

```bash
nix run github:ifiokjr/nixpkgs#serverpod_cli-4 -- --help
```

The installed executable is `serverpod`.

## updates

This package tracks the latest `serverpod_cli` 4.x beta version published to Pub and builds from the matching Serverpod GitHub monorepo tag because the CLI depends on sibling packages in that repository.

Run the repository updater from the repo root:

```bash
./scripts/update
```
