{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.16.1-pre";
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
    "aarch64-darwin" = "sha256-Pq8DWFuE6nsYJZB03hdCQwdnxSWrPssoS1yZvwydhlc=";
    "x86_64-darwin" = "sha256-svdULn8Er92O6IQLh39aTZZU3cUqdmp1tEGGL9PKD0A=";
    "aarch64-linux" = "sha256-G2fwWqHzAIFBLm+et77AL2yVkE7nBqfThDn8wjbyCOU=";
    "x86_64-linux" = "sha256-+EFaK0Gn3K3WclGpO/I45DNmd0TelLgEVj75iI+e+g4=";
  };
}
