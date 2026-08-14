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
  version = "4.2.1";

  hashes = {
    "aarch64-apple-darwin" = "sha256-n7dEkXh3rMaK4kIa741/RPDV6xZCjp09ssmLGuYf0jk=";
    "x86_64-apple-darwin" = "sha256-+Ahi1M+1UouloLbBo9stMhidVQlksCvrjdsWAJbN0a4=";
    "x86_64-unknown-linux-gnu" = "sha256-fzX5LBWGEmO8VAwAFGZnjS2iKBSaEHtR1bZc5JdgMHQ=";
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
