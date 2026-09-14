# melos

`melos` is a CLI for managing Dart and Flutter monorepos with multiple packages.

Use it to bootstrap package workspaces, run scripts across packages, manage dependency graphs, and coordinate testing or code generation in multi-package repositories.

## usage

```bash
nix run github:ifiokjr/nixpkgs#melos -- --help
# equivalent:
nix run github:ifiokjr/nixpkgs#melos_8 -- --help
```

The installed executable is `melos`.

## updates

This package tracks the latest 8.x `melos` version published to Pub and builds from the matching `melos-v<version>` GitHub tag. The `melos` flake output is an alias for this package.

Run the repository updater from the repo root:

```bash
./scripts/update
```
