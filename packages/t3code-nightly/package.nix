{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261011.2967";
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
    "darwin-arm64" = "sha256-3Wp/Z02v8i1G3227ybNhT/fbei/eU1u3h8cpS+yyY/8=";
    "linux-arm64" = "sha256-0z6vwQ1oDm/3RP+plpYL5SQbrMmSwO3Jyd+fSJTMY4k=";
    "linux-x64" = "sha256-y2A/cSXHOiHqAIX9S5E07tvM/P018HrctmGkEm06nL8=";
  };
}
