{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.14.1-pre";
in
import ../zed/package.nix {
  inherit
    stdenv
    fetchurl
    lib
    undmg
    makeWrapper
    ;
  channel = "preview";
  overrideVersion = version;
  zedHashes = {
    "aarch64-darwin" = "sha256-PLTRtGft4JiCMoj9vOrUsAj/5nEFNNGaRFI7PVLwjiI=";
    "x86_64-darwin" = "sha256-ip6kAF78ZquWR2rKYkZxZOC9PU2Stkrhq6TOuDH34qc=";
    "aarch64-linux" = "sha256-Vepwl2GO7KRyM4LjB2QOFYDU9EiHjeDj4veQQ/rH5CE=";
    "x86_64-linux" = "sha256-K53O0foF1AJyRBcQ68AGutlY4iQohPvRHgJ5Jd+IqXk=";
  };
}
