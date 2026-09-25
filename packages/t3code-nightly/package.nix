{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.43-nightly.20260925.2237";
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
    "darwin-arm64" = "sha256-fbbtSRSVTpAKlViiS766IBfXRX8teI+YdrJ8ieoZ8MU=";
    "linux-arm64" = "sha256-ArkfVUcuuiG+pC1CicZO9/8/zT15e9nSeDWGNnyoFbU=";
    "linux-x64" = "sha256-w9z4dck/DMra9nVPTzYcL2WdZmY+A0aofQemM/dHYzQ=";
  };
}
