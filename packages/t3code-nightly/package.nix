{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.6-nightly.20261030.3917";
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
    "darwin-arm64" = "sha256-Xr0R4AY5ESq1QpmfSDTPxqOetYKuneiITSAoXHuZZWg=";
    "linux-arm64" = "sha256-tRBMuo792noiqLIwd19hj8GpX9BbT8e1Ca2fCBpQg7s=";
    "linux-x64" = "sha256-+9BMSyDO8rkJy/TPuCmiZyRAvP1Pez3Ywf+6RYo6G6Q=";
  };
}
