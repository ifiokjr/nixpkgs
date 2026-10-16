{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.1-nightly.20261016.3190";
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
    "darwin-arm64" = "sha256-yBbE7B5zDixRunoHAEwNXSCRX8oRd5OG1f0GBMUZuww=";
    "linux-arm64" = "sha256-+ZFwpg1wkWRYZPag0v23B/oMLECesXV8oazc+Iq6c0o=";
    "linux-x64" = "sha256-IO1uwUZfC1NwN9KqWvAbI5+2EAhrZwBSdK3rre2IYj0=";
  };
}
