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
  version = "4.0.2";

  hashes = {
    "aarch64-apple-darwin" = "sha256-yoHA6Njt9W0IvTR9o9RJ92t9bL5n1axYKDK6tRsdU7I=";
    "x86_64-apple-darwin" = "sha256-UG+vd2ka1d+k0GGaSt+zshHDn/rxJ+sPs3Z5rHbWqdE=";
    "x86_64-unknown-linux-gnu" = "sha256-7JLe1FU22Cxze033BAS7wFLsFxF3PstWokDBHQ1xk3o=";
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
