# serverpod_cli

`serverpod_cli` is the command-line tool for [Serverpod](https://serverpod.dev), a Dart and Flutter backend framework.

Use it to create Serverpod projects, generate protocol and serialization code, run migrations, and manage Serverpod application workflows.

## usage

```bash
nix run github:ifiokjr/nixpkgs#serverpod_cli -- --help
```

The installed executable is `serverpod`.

## updates

This package tracks the latest `serverpod_cli` version published to Pub and builds from the matching Serverpod GitHub monorepo tag because the CLI depends on sibling packages in that repository.

Run the repository updater from the repo root:

```bash
./scripts/update
```
