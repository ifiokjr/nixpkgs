{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261009.2861";
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
    "darwin-arm64" = "sha256-RD4LwkQCEyeDRidsVxX8bRRX7oEaOSFW1Gg04g1ah4o=";
    "linux-arm64" = "sha256-3bDnWLTCgc1oGBvElcUB06/demRT3yXQk9i9tYiuqeE=";
    "linux-x64" = "sha256-dTftHUn8G464EnFBszqfC1/FPsA6g8t2VzKh3O053S4=";
  };
}
