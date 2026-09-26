{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.43-nightly.20260926.2282";
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
    "darwin-arm64" = "sha256-QP+D99pjru+j2i1zvVcvUzJDU6mLfYp0UwJAYM05LCY=";
    "linux-arm64" = "sha256-1nWqox91hExtv7SQF23/irdLCxoL3T1pR4EPEsD4aPQ=";
    "linux-x64" = "sha256-YCJgMJvAM+dl4iFt3cZqFrqwqq4viX2J558D9UEBCXw=";
  };
}
