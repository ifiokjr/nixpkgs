{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
  patchelf,
}:

let
  version = "1.26.2-pre";
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
    "aarch64-darwin" = "sha256-OWXEs/cB1AflOzrGVNlKHRBm4P3R9ZiQvM25jbpr7zY=";
    "x86_64-darwin" = "sha256-UoF0wKfTB7dKqwqwVQTjynjc2gj61j5dBn+uI/Ovu/Y=";
    "aarch64-linux" = "sha256-bJFhDy8ii+HxVeCTfmanNMmCCQP2gYkYkdvXMKMBS00=";
    "x86_64-linux" = "sha256-RfNehCJoRY+ExC+S31wC3sZwpJFT9KybgVeTaTxtnAg=";
  };
}
