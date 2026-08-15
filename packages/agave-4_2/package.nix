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
  version = "4.2.1";

  hashes = {
    "aarch64-apple-darwin" = "sha256-HIs69ehhThxFk5OpXFsZv7zI7ROCKhy1OfrmhHH5v7s=";
    "x86_64-apple-darwin" = "sha256-0ctxZYkgB9Ea1y/e0Wx2km5d+p/yhv49mZRAwa80p1g=";
    "x86_64-unknown-linux-gnu" = "sha256-fzX5LBWGEmO8VAwAFGZnjS2iKBSaEHtR1bZc5JdgMHQ=";
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
  pname = "agave-4_2";
}
