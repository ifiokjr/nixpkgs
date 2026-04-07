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
  version = "3.1.12";

  hashes = {
    "aarch64-apple-darwin" = "sha256-8q1QM0h5VP/ec3FzNoJ/ybn7EQMIQ+SVajDI0otY4/k=";
    "x86_64-apple-darwin" = "sha256-FkJMC5CazkW/sue2EIETyUB7gmKafm2Jrb2CDT6vzTo=";
    "x86_64-unknown-linux-gnu" = "sha256-TUXatsz+UyEpKtbcFS96znHMvd3l7NoKqj+Su/6O2AM=";
  };
in
import ./common.nix {
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
}
