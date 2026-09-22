# serverpod_cli-3

`serverpod_cli-3` is the command-line tool for [Serverpod](https://serverpod.dev) 3.x, a Dart and Flutter backend framework.

This is the older 3.x track. The default `serverpod`, `serverpod-cli`, and `serverpod_cli` aliases resolve to `serverpod_cli-4`; use this package when you need to stay on 3.x.

Use it to create Serverpod projects, generate protocol and serialization code, run migrations, and manage Serverpod application workflows.

## usage

```bash
nix run github:ifiokjr/nixpkgs#serverpod_cli-3 -- --help
```

The installed executable is `serverpod`.

## updates

This package tracks the latest 3.x stable `serverpod_cli` version published to Pub and builds from the matching Serverpod GitHub monorepo tag because the CLI depends on sibling packages in that repository.

Run the repository updater from the repo root:

```bash
./scripts/update
```
