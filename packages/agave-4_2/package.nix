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
  version = "4.2.0";

  hashes = {
    "aarch64-apple-darwin" = "sha256-dVK+dM1O7kMd6VO48HYe88FL3kDE6tydAlTTclQUTb0=";
    "x86_64-apple-darwin" = "sha256-iM6B+bZxP1b65APM3gbkcgR0ai0Ff0sdchzpTx8jKPc=";
    "x86_64-unknown-linux-gnu" = "sha256-H16xO882lNvTz2NGAq7l7c+Oq1GaysdXeDkcl5wwArA=";
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
  pname = "agave-4_2";
}
