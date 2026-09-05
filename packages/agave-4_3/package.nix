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
  version = "4.3.0-rc.0";

  hashes = {
    "aarch64-apple-darwin" = "sha256-ETVECRyF8cAXfpUxCxmr3CeOEbW6lHI+AgV1j7/q0vo=";
    "x86_64-apple-darwin" = "sha256-kukVyEz7bGVQrFL3w9rEU/vJe2JtA9llUOl4eeRPv8g=";
    "x86_64-unknown-linux-gnu" = "sha256-tkDhR7niKkKsOsEtBGn2kgbGqbUC7WbR5VXO04LZ4lg=";
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
