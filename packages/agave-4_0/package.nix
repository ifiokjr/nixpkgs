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
  version = "4.0.3";

  hashes = {
    "aarch64-apple-darwin" = "sha256-QVuX+s/USf7QajNwJzHLdVQ/BJHqd4E7AHpMS4+CXmE=";
    "x86_64-apple-darwin" = "sha256-7+XtRmZg800VdJot6T/Csv0/TWSFNr6GV9Udp/ZLd1s=";
    "x86_64-unknown-linux-gnu" = "sha256-UKbtBHTJWOHOP7opj0X8HNMRfbXF3yU8wMfYyCfoE6g=";
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
  pname = "agave-4_0";
}
