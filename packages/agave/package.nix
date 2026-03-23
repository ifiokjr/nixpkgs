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
  version = "3.1.11";

  hashes = {
    "aarch64-apple-darwin" = "sha256-gDjaeEORr4aQblrGuFWTtbaudF/g/4kCm9J6ll7llaI=";
    "x86_64-apple-darwin" = "sha256-5QxqTtrqWbzw+57jTpSmf60AUrMeckygShcv+cPT6us=";
    "x86_64-unknown-linux-gnu" = "sha256-WXjWIf4lgvwkA/oT88BlAgILy0LoBt3UYSFQBJ0aP7s=";
  };
in
import ./common.nix {
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
}
