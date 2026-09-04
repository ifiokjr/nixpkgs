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
  version = "4.2.2";

  hashes = {
    "aarch64-apple-darwin" = "sha256-WAu0vNtDl1ZkWoPYVpZKjXtwBRI1atqBmtiaQL12vKQ=";
    "x86_64-apple-darwin" = "sha256-ZSEoqONa2RhINHTShBWuP43nF8wjrJTxmluQGISBgm8=";
    "x86_64-unknown-linux-gnu" = "sha256-X8hoT3QwA4EF/elT1DCO1Wrd9if2WNqmFwnzRUSCR+4=";
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
  pname = "agave-4_2";
}
