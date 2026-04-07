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
  version = "4.0.0-beta.6";

  hashes = {
    "aarch64-apple-darwin" = "sha256-t9zfuhV8rwUzn87/N/spy62j4VyifrTT+kmnDbd4AGs=";
    "x86_64-apple-darwin" = "sha256-ITOusiHnIjuv7BA2QNDZNSqzFQZZ79BFdxDN0o2Ym/4=";
    "x86_64-unknown-linux-gnu" = "sha256-hbhar6iPv85csrOB/BXogtd7336E/xRGIEvj+zrVO2s=";
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
