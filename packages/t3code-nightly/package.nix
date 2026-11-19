{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.11-nightly.20261119.4928";
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
    "darwin-arm64" = "sha256-LsajcdOO7Gs/Es/Tzxy4IdW5YeTua34Fvh26h6amJHs=";
    "linux-arm64" = "sha256-CnHx1oLc8Vf5mQctiGm1yySc+zVUHZoVJfuAVOsmEvM=";
    "linux-x64" = "sha256-PTw/1SNz3KNmXX8O/36GqJ3A0bdtfVLnnudz9ug4E7Y=";
  };
}
