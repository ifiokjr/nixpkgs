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
  version = "2.3.13";

  hashes = {
    "aarch64-apple-darwin" = "sha256-sgRfLCyoyXuCczutpsnBG0YZbBrNjwDjN0Kn0sIGChI=";
    "x86_64-apple-darwin" = "sha256-GAFrNS/fzS2/46A4dO8vxWsicPh4DUdPelhcgKO5BQ0=";
    "x86_64-unknown-linux-gnu" = "sha256-xDU5699pQkcui4djXW6lX0KKUePQIZ97b3IPxrGfreA=";
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
    ;
  pname = "agave-2_3";
}
