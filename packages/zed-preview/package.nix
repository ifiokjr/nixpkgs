{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
  patchelf,
}:

let
  version = "1.31.0-pre";
in
import ../zed/package.nix {
  inherit
    stdenv
    fetchurl
    lib
    undmg
    makeWrapper
    patchelf
    ;
  channel = "preview";
  overrideVersion = version;
  zedHashes = {
    "aarch64-darwin" = "sha256-Oq4CasBf94PuEYXhdv5o0FFwWYIFumtbZTidxwkUHBI=";
    "x86_64-darwin" = "sha256-A97cYqH9nSQLUC6os3GGci0RDanl0Cud9bKjxaT8NMk=";
    "aarch64-linux" = "sha256-4DYdeeUL3S3QFlrliZSb/trWN+2HLSvZgqRjYXmQ4qI=";
    "x86_64-linux" = "sha256-7y3blmEhbHZ+usBQrv0M5qwrLk4jgg3Lfhg6FmYBEXQ=";
  };
}
