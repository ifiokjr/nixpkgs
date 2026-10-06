{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261005.2702";
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
    "darwin-arm64" = "sha256-Rgdn3ib9jt5QZXsh1bzeBXEj5RfvTQG9Rrzkyr/47tM=";
    "linux-arm64" = "sha256-EM5npVfE1yLS2jdRa8SBvq20sEldM/JpsX2tDwIivMc=";
    "linux-x64" = "sha256-s3f5x6wEsZD67c6ArH/LGddtY9a+Wdqr5I7bso7o1TI=";
  };
}
