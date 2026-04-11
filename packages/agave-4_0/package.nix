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
  version = "4.0.0-beta.7";

  hashes = {
    "aarch64-apple-darwin" = "sha256-nCph542fw4hY+z7lgN7X6t2kq7FG5ojANUSvRGs3URo=";
    "x86_64-apple-darwin" = "sha256-y8aYBpdfWL5UBJxYnRmkDzcydSjDrCvW41ndNAourEE=";
    "x86_64-unknown-linux-gnu" = "sha256-7PeBEF0vPOX0c6CCw6w9NKhl3uUXMUuUTUrmuASVExE=";
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
