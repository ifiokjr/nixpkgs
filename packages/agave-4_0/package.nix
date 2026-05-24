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
  version = "4.0.0";

  hashes = {
    "aarch64-apple-darwin" = "sha256-eRln77dFyV+PaHaJIy6JV40rVAGJveLJnemHlPBoT/U=";
    "x86_64-apple-darwin" = "sha256-THsS0arYSmksetN0yKN+ViVc6CvMq2iwKl5AvDstQSE=";
    "x86_64-unknown-linux-gnu" = "sha256-yDm6Yp0Q7dX5mvaIB9wllI/OYs1RdrVq0T4j91Yu9PI=";
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
