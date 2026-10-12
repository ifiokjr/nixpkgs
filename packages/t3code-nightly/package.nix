{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261012.3010";
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
    "darwin-arm64" = "sha256-tuPZwqJjWwQkpcRe4ufiVFl10d7X7tpZKFKnNJGR2Kk=";
    "linux-arm64" = "sha256-BcGEAL0uLiWLSB1JcFX1LOJbgVGRqqn3PdTk61stJss=";
    "linux-x64" = "sha256-54v3L5UWTPsFoMi1ABwUj+WGR1rq6o1oXC02seLcyHY=";
  };
}
