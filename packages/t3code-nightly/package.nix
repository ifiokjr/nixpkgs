{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.43-nightly.20260928.2375";
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
    "darwin-arm64" = "sha256-7AWUunCHZHss9iMKZfB5yANKPvmiA7R6n62L4rU33ds=";
    "linux-arm64" = "sha256-tG5ZRMd1lf3F+ztePLpcP5bAsA1h52/qDg2j67MuaV4=";
    "linux-x64" = "sha256-6ut5RQHzq/oF70luqj4yzuF58NuWWcgwS/WNXWTSx9c=";
  };
}
