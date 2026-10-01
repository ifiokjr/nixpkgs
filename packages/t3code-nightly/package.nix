{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.45-nightly.20261001.2525";
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
    "darwin-arm64" = "sha256-NdejCxy6YHx4rEuqYoBMGyZpcX3vhA6+sXou53Uicm0=";
    "linux-arm64" = "sha256-j0SI9IcfEfb2NANu54O+Shcy86+UOICXkyjb4OSKets=";
    "linux-x64" = "sha256-Mytjf1QcO4EIT6prhoCPOIPo8+H7/bKJN2/h53XBF88=";
  };
}
