{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.12-nightly.20261124.5191";
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
    "darwin-arm64" = "sha256-hqPemkHLN+VaT1Min+sFZnFj48xJ3Kt8qi7k6LHtf1Q=";
    "linux-arm64" = "sha256-fO7K3LtQUwUFOuvpK1r+os85sKnM82AnbVnHBdy2na4=";
    "linux-x64" = "sha256-4UrXm2SZ3Alatv9Cdtxcf38hihTs0loZDvkBtiE9IF4=";
  };
}
