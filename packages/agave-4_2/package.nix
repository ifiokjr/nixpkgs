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
  version = "4.2.0";

  hashes = {
    "aarch64-apple-darwin" = "sha256-dVK+dM1O7kMd6VO48HYe88FL3kDE6tydAlTTclQUTb0=";
    "x86_64-apple-darwin" = "sha256-iM6B+bZxP1b65APM3gbkcgR0ai0Ff0sdchzpTx8jKPc=";
    "x86_64-unknown-linux-gnu" = "sha256-H16xO882lNvTz2NGAq7l7c+Oq1GaysdXeDkcl5wwArA=";
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
  pname = "agave-4_2";
}
