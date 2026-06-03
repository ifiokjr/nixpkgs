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
  version = "2.0.25";

  hashes = {
    "aarch64-apple-darwin" = "sha256-OgiAuH1UNfHgYp8QA7bE9/9TJ47hS5GbH9pzHfIniPg=";
    "x86_64-apple-darwin" = "sha256-nWm/05BDNUEq7peHpHbcy0Bf9HFj78WOqiRCalPb40M=";
    "x86_64-unknown-linux-gnu" = "sha256-OtWVwqL+Jy7l5FvNehiLwenKzFQ4xdqBm9DwDiHeyqc=";
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
