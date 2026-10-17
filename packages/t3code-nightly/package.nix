{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.1-nightly.20261017.3238";
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
    "darwin-arm64" = "sha256-AIqEnZzvGNUvviVPcW6OXqpc4Rexbww1Pwijtu6ZFn8=";
    "linux-arm64" = "sha256-DcZqUc0yG6cSe0y0IYCUWBbvASK4Oow1TelOjGRbhG8=";
    "linux-x64" = "sha256-GF4nuqdRBQoqoMEfDFomUlZVzD9bcQrtpo4s8HKkITs=";
  };
}
