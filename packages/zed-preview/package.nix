{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.13.1-pre";
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
    "aarch64-darwin" = "sha256-lKYFOj17N+GxDcEkyvPYrLWkkkjjSwCgerR3XXao0Mk=";
    "x86_64-darwin" = "sha256-ctVtGdc9ltH1QwIB9KcaBn2iY2APsGNKONEbGWdux1A=";
    "aarch64-linux" = "sha256-BEKoAVhvrVLOikt84snzRGT+/ZmYa/zdrEPYdpWZvYA=";
    "x86_64-linux" = "sha256-9hWq9lgIsf88roJTwc4B2Kvu9PbEN/kF13jyPDbydCU=";
  };
}
