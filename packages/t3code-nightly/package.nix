{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.14-nightly.20261127.5332";
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
    "darwin-arm64" = "sha256-Isdyi/oOeShDeaxkndnwgmXLkaeKLGyy5lXihVq3lJw=";
    "linux-arm64" = "sha256-/btjdJJ0Ix8ce/mumsGq3qjvClKVtbQS4MnEaxxC9jg=";
    "linux-x64" = "sha256-TE4AYt2SOUmO5kc8IjnrErsb1m7wnPVs4co2JFuVdmc=";
  };
}
