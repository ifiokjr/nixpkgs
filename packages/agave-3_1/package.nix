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
  version = "3.1.13";

  hashes = {
    "aarch64-apple-darwin" = "sha256-idr5YgLFbttrMzgA7Oojm/pEc8bBilwG0ca1EOIa7s0=";
    "x86_64-apple-darwin" = "sha256-HbCalF0PJZ6wyuIJlrrmyYLevcdwjZXkM8w2pvBypMw=";
    "x86_64-unknown-linux-gnu" = "sha256-iN8A98I/hKpif5GB+CMdKqEK2nyqn/Wn9yh7fvfQu+g=";
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
  pname = "agave-3_1";
}
