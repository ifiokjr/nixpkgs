{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.1-nightly.20261019.3348";
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
    "darwin-arm64" = "sha256-K0g5n6bnZ6GP/efT53lpOfOVxkKa30guIqXBLJF0/U8=";
    "linux-arm64" = "sha256-qO1KrVMlE2MOIiTPZa3B6rsS9I1QRJNZnsfILYw+sBo=";
    "linux-x64" = "sha256-q7pLdpvlOCMP/Z0ArREUi345YUqUeFkir6sK55sYkj4=";
  };
}
