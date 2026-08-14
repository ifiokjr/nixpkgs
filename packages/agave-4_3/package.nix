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
  version = "4.3.0-alpha.3";

  hashes = {
    "aarch64-apple-darwin" = "sha256-tzWqWVS3cHqSYMWU7fz/JSUPfeoTEnawUyujM/TW67o=";
    "x86_64-apple-darwin" = "sha256-qpgwSrWHSOPj16xqinhZr3dy4B1ozIMHN9qVIILTMH4=";
    "x86_64-unknown-linux-gnu" = "sha256-lpJlmsi5Sx74qGFr2s1rlwaiQrLVxWHJ4/HP6x5EEms=";
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
  pname = "agave-4_3";
}
