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
  version = "4.3.0-alpha.3";

  hashes = {
    "aarch64-apple-darwin" = "sha256-tzWqWVS3cHqSYMWU7fz/JSUPfeoTEnawUyujM/TW67o=";
    "x86_64-apple-darwin" = "sha256-qpgwSrWHSOPj16xqinhZr3dy4B1ozIMHN9qVIILTMH4=";
    "x86_64-unknown-linux-gnu" = "sha256-lpJlmsi5Sx74qGFr2s1rlwaiQrLVxWHJ4/HP6x5EEms=";
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
  pname = "agave-4_3";
}
