{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.7-nightly.20261101.4016";
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
    "darwin-arm64" = "sha256-jOEqx63Jjh1QWfA7FKuAufz8tiReEG4bCbICoGEsce0=";
    "linux-arm64" = "sha256-idc6IfFPDmRffVhM4xhbXzX/QSl8yuEIlhvpBrhtxAU=";
    "linux-x64" = "sha256-/D/jq6oa/yKE6fMUTfFQ1NFu8oQTTSR8790OJI/3ly0=";
  };
}
