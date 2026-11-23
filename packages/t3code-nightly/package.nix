{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.12-nightly.20261123.5151";
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
    "darwin-arm64" = "sha256-XQPCKIIo0wBmwB01w6LVv6E7R3KlxwcBzHvw/js+5w8=";
    "linux-arm64" = "sha256-9qysXxdzE6+uoSE5tDuXRR4k358LGp84ISwdCVIiKWs=";
    "linux-x64" = "sha256-qfJeSQSGOirD0f+ZKTeZd88CYgW7e/rIG42g8OVbBiM=";
  };
}
