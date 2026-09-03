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
  version = "2.2.20";

  hashes = {
    "aarch64-apple-darwin" = "sha256-ov9OYm/I1IjPICslINyUjN1n9+Rr3rJVDnkKDUB60Qk=";
    "x86_64-apple-darwin" = "sha256-QxgaW7XUEAk7PFVw94a5vbOnTnB6EPNVJCIcAbcg9uY=";
    "x86_64-unknown-linux-gnu" = "sha256-ybV8yKNrVMIbXen5BlIXSZCCRG7//iLLY2xYsoWKzqo=";
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
  pname = "agave-2_2";
}
