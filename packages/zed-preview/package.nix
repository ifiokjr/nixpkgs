{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.23.1-pre";
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
    "aarch64-darwin" = "sha256-cOBLou0jAfOCN9n97iE+r2VQwXpMWss+A1PkYo0S6rY=";
    "x86_64-darwin" = "sha256-Qt6EDtaEajSRwmaxK1RpHV7rky4pZDKD6qtU7A+PNAY=";
    "aarch64-linux" = "sha256-1ABF1A3xTvTfTaOK2vS8T3fk+y+ozlWV5QMeebndx0w=";
    "x86_64-linux" = "sha256-RCqNf1bO2fyN8ybIETTSYGt6ZYNwhPVitKKIPtKS0Gw=";
  };
}
