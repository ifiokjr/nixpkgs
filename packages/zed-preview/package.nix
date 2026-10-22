{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.26.1-pre";
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
    "aarch64-darwin" = "sha256-SPNcz+cCazw9w9t0oxOoPts7nGrOLTIODp5+jP2W+8M=";
    "x86_64-darwin" = "sha256-T7q7V7gvE5bznJpATYWZMZxd6hZO4h0QS5561hHKCB8=";
    "aarch64-linux" = "sha256-ystBzvOxWhxJDCxz8lccdZGVEBP8FTGwPZd+0J0SP34=";
    "x86_64-linux" = "sha256-wO0//7N8UtpPa+FaYoP/m4py0GF1KNMFn4333YzJgo0=";
  };
}
