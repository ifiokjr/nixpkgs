{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.14-nightly.20261127.5359";
in
# Nightly channel of the same self-contained CLI archive. Both packages install
# `bin/t3`, matching the other version tracks in this repo (pnpm-10/pnpm-11,
# melos_6/melos_7/melos_8): install one of them, not both.
import ../t3code/package.nix {
  inherit
    lib
    stdenv
    fetchurl
    autoPatchelfHook
    ;
  channel = "nightly";
  overrideVersion = version;
  t3codeHashes = {
    "darwin-arm64" = "sha256-8mBNWLj0vruMvQdKx8Our6Wh+MlLK8CPkmQ/nHBUGKs=";
    "linux-arm64" = "sha256-GPWMyUCk0olzN2PlLOZdC4tZjEf3QlQwrL82PQ52R0I=";
    "linux-x64" = "sha256-EjgqVlok3U+bYstd2WcrQCCl+a8n9QQdXJzYNgtM5TU=";
  };
}
