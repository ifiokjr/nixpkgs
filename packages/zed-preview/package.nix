{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.19.1-pre";
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
    "aarch64-darwin" = "sha256-58ib3Xlh3qHIUH2P6RSkVahPuFPxVBiUq7QDOmPf+q8=";
    "x86_64-darwin" = "sha256-9HcSM6NGH2nOuPr2o9lS2cLNM28j8UhFIBZu01QXR+8=";
    "aarch64-linux" = "sha256-fappDEFrno9T05lceYGCHi2Kg42BP9de1PeENHG4+fw=";
    "x86_64-linux" = "sha256-lWTKyMZDdg+U+MIg9Qy66VyHeFJCie2W50SvLH0J4EM=";
  };
}
