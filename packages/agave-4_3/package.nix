{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  lib,
  zlib,
  openssl,
  udev,
}:

let
  version = "4.3.0-beta.2";

  hashes = {
    "aarch64-apple-darwin" = "sha256-Nv1DJA/r5J1TgY6kshqBpM1fAY+FpzwwfdF719hLbdI=";
    "x86_64-apple-darwin" = "sha256-MDlw7tvj8BGNi4POhQ7QS5DFvVOlxSbKZm5UiBJi6Tg=";
    "x86_64-unknown-linux-gnu" = "sha256-y2kgEQF1tY/Fn8Zv5F2w1jLf8xKZ7qeNuBed3uas8EI=";
  };
  platformToolsVersion = "v1.54";

  platformToolsHashes = {
    "aarch64-apple-darwin" = "sha256-HIs69ehhThxFk5OpXFsZv7zI7ROCKhy1OfrmhHH5v7s=";
    "x86_64-apple-darwin" = "sha256-0ctxZYkgB9Ea1y/e0Wx2km5d+p/yhv49mZRAwa80p1g=";
    "x86_64-unknown-linux-gnu" = "sha256-/MQWMcf3dWG/VBIhi/KXUB3M8DBeooDzOPCs4qq58x4=";
  };
in
import ../agave/common.nix {
  inherit
    stdenv
    fetchurl
    autoPatchelfHook
    makeWrapper
    lib
    zlib
    openssl
    udev
    version
    hashes
    platformToolsVersion
    platformToolsHashes
    ;
  pname = "agave-4_3";
}
