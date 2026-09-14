# melos (7.x)

`melos` is a CLI for managing Dart and Flutter monorepos with multiple packages.

Use it to bootstrap package workspaces, run scripts across packages, manage dependency graphs, and coordinate testing or code generation in multi-package repositories.

## usage

```bash
nix run github:ifiokjr/nixpkgs#melos_7 -- --help
```

The installed executable is `melos`.

## updates

This package is pinned to the latest 7.x `melos` version published to Pub and builds from the matching `melos-v<version>` GitHub tag. Use the `melos` output for the default track.

Run the repository updater from the repo root:

```bash
./scripts/update
```
