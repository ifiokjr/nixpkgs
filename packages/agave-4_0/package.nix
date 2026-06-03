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
  version = "4.0.1";

  hashes = {
    "aarch64-apple-darwin" = "sha256-edAnJaqEMoJnRzXAVqhHDZFo+eVrN8Og3jdGr9gcJQY=";
    "x86_64-apple-darwin" = "sha256-839mSli42h+Yp46SFbjdGTDd5JGBsel19GCGS/4wLhw=";
    "x86_64-unknown-linux-gnu" = "sha256-+3hliJXE16jb3StQ9U8Wfbh7QHJBfnPIyF2hKjtVUgk=";
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
