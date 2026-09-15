{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.20.1-pre";
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
    "aarch64-darwin" = "sha256-uc+JqecrOTSFQppv3E85mZUzcKvFpel0teThQPEGfhw=";
    "x86_64-darwin" = "sha256-5J0T5jdTsjzgwU5zgODsMtXHsG9i4/NIak7/eWa8P70=";
    "aarch64-linux" = "sha256-rRwH6DxYI+sepcc/fN6Dthr3RF81LUTW9S32M6Ns9pk=";
    "x86_64-linux" = "sha256-JWksRXeYvdweIwuR7I94V5ZPudfNJ9bB+g1G0LDHu7M=";
  };
}
