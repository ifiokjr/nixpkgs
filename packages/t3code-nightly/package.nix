{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.14-nightly.20261127.5345";
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
    "darwin-arm64" = "sha256-erB92cGgyAts+31u9T02NSRMgUr4zIMAcKoKAQNJqC8=";
    "linux-arm64" = "sha256-TEtTkuc29j9Cn6iJaMC9fVN+w/QslRJ/HoQy8SumZdY=";
    "linux-x64" = "sha256-G9d9CJRDYThv+0buCyQl8kHOMGSMHsRSsf6ZajfNOXo=";
  };
}
