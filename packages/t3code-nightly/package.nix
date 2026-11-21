{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.12-nightly.20261121.5038";
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
    "darwin-arm64" = "sha256-X+NishXB7qQkQ88pphoZoMYMqrcxyDcEW0DDd/NKEPo=";
    "linux-arm64" = "sha256-/pfuVNUg/vCb2st006uMGqnb7HLqoZPEm9wpIeRWYhk=";
    "linux-x64" = "sha256-OgQjGjPs+um45sm9SB5ugFO8A3K/UyFg84U3unDGVTY=";
  };
}
