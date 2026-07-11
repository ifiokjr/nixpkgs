{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.11.2-pre";
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
    "aarch64-darwin" = "sha256-ZDwfWfP5U0JNTvX96IEtKSiLdH7SyBHGNJPw9OFZHAM=";
    "x86_64-darwin" = "sha256-5MlxSMz8aXjtdbKXzcGB53E/kllupossREO69QwJZxw=";
    "aarch64-linux" = "sha256-PT7RiTStzd+JN1aFgRwNKCVBCKe31n0mJKR+l1VvCOo=";
    "x86_64-linux" = "sha256-BJpcLENuyUmgyvNJ7tqtmp9owNauqNzOGwU3AEN1AHU=";
  };
}
