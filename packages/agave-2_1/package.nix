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
  version = "2.1.21";

  hashes = {
    "aarch64-apple-darwin" = "sha256-ihKRFoV0hAy7D+ndIlQPdxH2wuwMH+EBq0vfRNpfKLA=";
    "x86_64-apple-darwin" = "sha256-oEbksNMDfvda5s+hNL7k8rdT9RJ77Acc7Nnc2qkDdBk=";
    "x86_64-unknown-linux-gnu" = "sha256-XaM1nilvHmwTUiuHQxfLTP4z5zMBqdxgseFDXMEzs5c=";
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
  pname = "agave-2_1";
}
