{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.1-nightly.20261018.3302";
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
    "darwin-arm64" = "sha256-a9S6YX0yHzGsDEv/4VSrFL+e2NZ6fCRNy9pMX5WBxSE=";
    "linux-arm64" = "sha256-z9BLTAduuYWokCgeL0jBSA9YHAjGfdyeoA+/Mb4vZDw=";
    "linux-x64" = "sha256-oEno3F7/hOJYUHE8coGVqE8gOU73Keg0LMaetzNEACM=";
  };
}
