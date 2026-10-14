{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261014.3105";
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
    "darwin-arm64" = "sha256-Wflelw/oFzDrUVWzj8/YZoU25UwpxDbnAq6s2SkC//4=";
    "linux-arm64" = "sha256-yVu4p18XL7joFn0AJNQrjxPCFah6MFAtqoQNbBldaks=";
    "linux-x64" = "sha256-YlHPvrItNoe5TPZW2N1keKNwqKgTCktDu4p7k4dlz+U=";
  };
}
