{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261010.2922";
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
    "darwin-arm64" = "sha256-9nmZoPmoS8cFvpmO22FSgAgU74UEZpKTgzbVOP9d/5c=";
    "linux-arm64" = "sha256-WzRxiROxmlm13w1mDi1x3gc6d+k7JYvRd1pK+krWm6A=";
    "linux-x64" = "sha256-LGbJkEMj7pRtCCX2MJfc36H6H3eafmPcYPF3vm7cBGE=";
  };
}
