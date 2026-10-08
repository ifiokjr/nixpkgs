{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261008.2819";
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
    "darwin-arm64" = "sha256-S+y28UC3Kk024vRAEPMTZG1AnsRwEDlWAMR6F7XyEIk=";
    "linux-arm64" = "sha256-147lcZdfHorY1GIl/0DO1TCssj1LMVJ4ozz0pAGOBMs=";
    "linux-x64" = "sha256-s95tFL9QfiU6DLU6GMZ+UdjEPKbwPgZxik5p+40w37U=";
  };
}
