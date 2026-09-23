{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.43-nightly.20260923.2135";
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
    "darwin-arm64" = "sha256-ZiNYqhV6CPJdBI/j1AnvzDe6auc7prC14NkxwHHOrrw=";
    "linux-arm64" = "sha256-TYsCZ+UJM+rCPD+iKLHizEtPfQWDOKJG5IS2tolB0+0=";
    "linux-x64" = "sha256-hDUXuGcb4cTWpgsenn83S6wInAqDY8jUZkcovc5dpDQ=";
  };
}
