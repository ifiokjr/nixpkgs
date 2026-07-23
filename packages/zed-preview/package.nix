{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.13.0-pre";
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
    "aarch64-darwin" = "sha256-tWn1F90mO8AsTjJ333cG+Y1cF4v4bI29Zg65djqGDKM=";
    "x86_64-darwin" = "sha256-6dYSjhROO8yYgLFcDt844Y8MDdn6Fj7d78adx6Z5PNk=";
    "aarch64-linux" = "sha256-y1BvkVu851cjgwUVaOOTYmQ0qpCzw3hM9lfVCR9ZTtc=";
    "x86_64-linux" = "sha256-5l9IcAsYd/TnYB5y1e8aX4BNU97IeLgXWmfOPdJMMbc=";
  };
}
