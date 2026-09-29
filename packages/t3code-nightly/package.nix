{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.43-nightly.20260929.2428";
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
    "darwin-arm64" = "sha256-u1cENVgIdZo2LKIAghAvoGdHAoHEvISaNbE9zM3VmEw=";
    "linux-arm64" = "sha256-+75B2Fimt7qmgNsgfY/gGQWU1z+LMt54IMc0wYyczo0=";
    "linux-x64" = "sha256-Z4hJBfnHTLsHxgRbEPVKj61YeE0M9r4DiF825uvEjlY=";
  };
}
