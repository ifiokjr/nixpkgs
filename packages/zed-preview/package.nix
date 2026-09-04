{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.19.0-pre";
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
    "aarch64-darwin" = "sha256-sBYq6zKAGjLUpi1/HFxMGhEEYb1wW4u561lmFgAx+KA=";
    "x86_64-darwin" = "sha256-S42Hik92rkmvtAdc1BzathOWh5GSvxZaq40rQTnzWHQ=";
    "aarch64-linux" = "sha256-Eii0uttROQ/UeKM+qW5uabaWziso4oClDj2XXTs5peA=";
    "x86_64-linux" = "sha256-Myi1i2VSIssAzqXkJtNTc2H4jTgSBs5NEDo7FEsDuQY=";
  };
}
