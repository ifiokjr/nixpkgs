{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261013.3053";
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
    "darwin-arm64" = "sha256-UfUhvslYii14bZT6cosBQDxP8gQ5GI312My8PC5vgTk=";
    "linux-arm64" = "sha256-DeexCba4idsnYQcbu7sdPHOFrIbYFpkQ7jH1QWCx+9g=";
    "linux-x64" = "sha256-pO9VWMEmIE9fMTpwsS5ajfLrCiXA+CzkvnfYJTRaxMk=";
  };
}
