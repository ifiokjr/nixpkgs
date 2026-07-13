{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.11.3-pre";
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
    "aarch64-darwin" = "sha256-wM1ddtstPHadhgCUVcR3bsEgrzrTNvUc4IzpsgWfhF8=";
    "x86_64-darwin" = "sha256-mxQvAWyTHlIYbckkiEtWuDExIrdWGGOVldBuos99myw=";
    "aarch64-linux" = "sha256-4WGoejBGklqp0K+OSopWDUOF24OvnUMIq+1U1b86rmw=";
    "x86_64-linux" = "sha256-RbAZBNMgfUtkVukGDFnimpnDLVTGMCjK6nVtn5dYz6E=";
  };
}
