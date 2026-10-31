{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.6-nightly.20261031.3977";
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
    "darwin-arm64" = "sha256-PCS5f3X05SiodTWX8yjPbLDwx9Q38GAZ8sXuTwwV40Q=";
    "linux-arm64" = "sha256-kfwtfqZRs2bXhi23kpGQzcW+tO4RPbElH+rxUDVBYks=";
    "linux-x64" = "sha256-bcUXE7q0VOKbU/Xx7ng1C9Rzw6ofEGpWMmIb0QBUit4=";
  };
}
