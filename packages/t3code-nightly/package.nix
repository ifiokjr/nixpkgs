{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.12-nightly.20261120.4994";
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
    "darwin-arm64" = "sha256-z+R+7cJFEDkWx6wL+EiNBSYfkiVpUReV6reves9iwD4=";
    "linux-arm64" = "sha256-Ri3A1hel2WaKmDU6eTIPpsxcmIPUnqXfvSC8UPY6QPg=";
    "linux-x64" = "sha256-iKRaTZ30cDhDB7kButc07K60f/iGsnDmemblzFGsaGE=";
  };
}
