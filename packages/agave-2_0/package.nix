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
  version = "2.0.21";

  hashes = {
    "aarch64-apple-darwin" = "sha256-zJAzm3eaGvspk6nd6j8600d0JqUbxl/EXXMnvglSNWY=";
    "x86_64-apple-darwin" = "sha256-6VBBubSHkJ4XakBqwsOFx3vApn02VgYI8DeNg2k8kxE=";
    "x86_64-unknown-linux-gnu" = "sha256-44w3SDSkHNmjPvww7gBqXOpdS7sSx41wRmaGQIWoRyg=";
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
  pname = "agave-2_0";
}
