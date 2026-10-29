{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
  patchelf,
}:

let
  version = "1.27.0-pre";
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
    "aarch64-darwin" = "sha256-PR+6os/5Oy7NEFj6h6z5jtmjx+0TtADFrv+5u4ZopXk=";
    "x86_64-darwin" = "sha256-dAM7dyI/+1BQ/hnjj+W8yvC3/V0FsxvGfkAKApuhCXk=";
    "aarch64-linux" = "sha256-f7VNVAzVBwRRQUSHx0wINzDNBlVaQ8zFvq0C5ByvaVQ=";
    "x86_64-linux" = "sha256-y9XdhnNLKszRTRLYqMTS6UhRxdzxnBb7J7FPzzc4u2M=";
  };
}
