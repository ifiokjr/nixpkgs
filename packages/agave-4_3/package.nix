{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  cargo,
  rustc,
  rustup,
  lib,
  zlib,
  openssl,
  udev,
}:

let
  version = "4.3.0-beta.3";

  hashes = {
    "aarch64-apple-darwin" = "sha256-1FxyWf80ZSs9RpYyKqTVLjoDZInBBkSWZCqdbGh9pss=";
    "x86_64-apple-darwin" = "sha256-rSjuYwQT+tTRZnIW+kU/9S1uZ1UhIY3UCfh4r90rxhM=";
    "x86_64-unknown-linux-gnu" = "sha256-y8Q+tx+AuX3mUCw0guz/00t/RZ1ebp5aYE52bQ8cxPQ=";
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
    cargo
    rustc
    rustup
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
