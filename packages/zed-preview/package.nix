{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.11.1-pre";
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
    "aarch64-darwin" = "sha256-y/qjxsqIdgIMDACEPnHaVKHFIu/yX3I9fsj+eEM5phc=";
    "x86_64-darwin" = "sha256-bRYZ/4ZD+vE9quPQyhijeRIzHObxTHkVdk8eIE5VFGQ=";
    "aarch64-linux" = "sha256-/JJReR8/sUXiUV0EfbdCftxaa87ZPy1HIWOGQlMmeLg=";
    "x86_64-linux" = "sha256-l8gZZKHj1AJz2i8fRyspVQBag8itr99S6GMiR+fPxzU=";
  };
}
