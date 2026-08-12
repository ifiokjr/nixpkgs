# patrol_cli

`patrol_cli` is the command-line tool for [Patrol](https://patrol.leancode.co), a Flutter-native integration testing framework.

Use it to build test apps, run integration tests on Android and iOS, and manage Patrol development workflows.

## usage

```bash
nix run github:ifiokjr/nixpkgs#patrol_cli -- --help
# aliases:
nix run github:ifiokjr/nixpkgs#patrol -- --help
nix run github:ifiokjr/nixpkgs#patrol-cli -- --help
```

The installed executable is `patrol`.

## updates

This package tracks the latest `patrol_cli` version published to Pub and builds from the matching `patrol-v<version>` tag in the LeanCode `patrol` GitHub monorepo.

Run the repository updater from the repo root:

```bash
./scripts/update
```
