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
  version = "4.3.0-beta.0";

  hashes = {
    "aarch64-apple-darwin" = "sha256-os4FnwVjiExYJaaAn6bJNHkEEezVMvg5AYpoHTCW9HY=";
    "x86_64-apple-darwin" = "sha256-ciCCq36D3nb98S0VacPXTQ+++Xdz4o6jr90fWKVpnQ8=";
    "x86_64-unknown-linux-gnu" = "sha256-LunJppPrLC25FAzQTpjb4pDcFitmnrVTPaZF25TnB8o=";
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
