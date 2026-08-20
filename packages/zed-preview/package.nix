{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.17.0-pre";
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
    "aarch64-darwin" = "sha256-xspK5Lq4yeAl10RL13j8QC91flA18oKaCmHtvcvImlg=";
    "x86_64-darwin" = "sha256-vgkVgaRTsrO0XFH8LSuUaYNvsiqTHyJd6TtuthXShvU=";
    "aarch64-linux" = "sha256-krkdOCcs4XEd9cVuJVCcCfuZB1d+Ttyf/CBs32bQ96I=";
    "x86_64-linux" = "sha256-TXjuWbp8esZ8X9CFAOdoAgHibK23Pd70ezE8lvRhEwc=";
  };
}
