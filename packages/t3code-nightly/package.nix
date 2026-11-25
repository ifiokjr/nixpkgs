{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.13-nightly.20261125.5245";
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
    "darwin-arm64" = "sha256-qwGp8hc1J4kQIAe/pV8+/uAIXd7OL0b2dX84hjTcSfs=";
    "linux-arm64" = "sha256-xaZ8hKPwRhU6fuyiwHiSnT4NaynuHW2EOTJb1vX40SQ=";
    "linux-x64" = "sha256-3jMXdcDvQ27fRGAhwFuS0heHQk7+XoszaZwEcQ8XUVI=";
  };
}
