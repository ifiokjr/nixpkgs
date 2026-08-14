{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  lib,
  zlib,
  openssl,
  udev,
  zstd,
  ncurses,
  libedit,
  libxml2,
  libffi,
  python3,
}:

let
  version = "4.1.2";

  hashes = {
    "aarch64-apple-darwin" = "sha256-UaRDGOb7i+DPppzf2zJS9MdqXrKGZ0BpTpHePS/Fp1s=";
    "x86_64-apple-darwin" = "sha256-62eP5QXKRw1LR0oKkqHW3WwAyV30fuTYygcS/nqX76E=";
    "x86_64-unknown-linux-gnu" = "sha256-WZHQJ6aG60GacJpHkXizPrg1Aeiiv79ZmoGihr/L93A=";
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
    zstd
    ncurses
    libedit
    libxml2
    libffi
    python3
    version
    hashes
    platformToolsVersion
    platformToolsHashes
    ;
  pname = "agave-4_1";
}
