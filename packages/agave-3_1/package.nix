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
  version = "3.1.14";

  hashes = {
    "aarch64-apple-darwin" = "sha256-VM/CaAvWQm/aBGGe4Bkz9ApknIBW86Ybog3FTdQn6+0=";
    "x86_64-apple-darwin" = "sha256-43aO0B2qHjz8Aq8+PrOWzsLUipns+AzV173/UQ+AjR8=";
    "x86_64-unknown-linux-gnu" = "sha256-Bvl8BlzJd8vsLxP/ybydO5L+9IVDH8s3Ciad5pUy71E=";
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
