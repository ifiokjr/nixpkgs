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
  version = "4.1.2";

  hashes = {
    "aarch64-apple-darwin" = "sha256-UaRDGOb7i+DPppzf2zJS9MdqXrKGZ0BpTpHePS/Fp1s=";
    "x86_64-apple-darwin" = "sha256-62eP5QXKRw1LR0oKkqHW3WwAyV30fuTYygcS/nqX76E=";
    "x86_64-unknown-linux-gnu" = "sha256-WZHQJ6aG60GacJpHkXizPrg1Aeiiv79ZmoGihr/L93A=";
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
    ;
  pname = "agave-4_1";
}
