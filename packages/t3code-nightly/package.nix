{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.45-nightly.20261002.2572";
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
    "darwin-arm64" = "sha256-f80dkDE5q+QZAIPsf6ok+rKc0J/5PJh6DyLcM9vPL+o=";
    "linux-arm64" = "sha256-jvtLa85rrc+9/mU72QuNzUsldMDoQjJfuRsnaQU6wMQ=";
    "linux-x64" = "sha256-1mpg8gKsbPqEx2KtcIr3fBfIZM9LQS5dmjB9U3xZp0E=";
  };
}
