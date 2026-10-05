{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261005.2676";
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
    "darwin-arm64" = "sha256-ndQ5H7YcL2YWbj2KAB7oPIf9smpUThlDFedUHBuhOz8=";
    "linux-arm64" = "sha256-DuBtNlwtf9EU5hhKdhl+DTa5GjjXvzz0COkS6/e0dQg=";
    "linux-x64" = "sha256-MRRhiU4/F1l78Y5NpQ2MhDyKMocUXjEFjSLDHBHfgMY=";
  };
}
