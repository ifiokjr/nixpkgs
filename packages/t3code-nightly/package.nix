{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261004.2648";
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
    "darwin-arm64" = "sha256-W54PtxS4dsEc1ruJGHcPMYcdn6X+0tn8dSHbF1f5/T8=";
    "linux-arm64" = "sha256-5rijj4rEtI0xMAIdTz5Cm4R9WSGEzTYMz6CDBmaXoEQ=";
    "linux-x64" = "sha256-Opky1SaAs+/DoqlrIFj4nDWudhx94SKI+HE1ynUWFPA=";
  };
}
