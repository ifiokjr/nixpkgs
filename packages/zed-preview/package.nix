{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.21.0-pre";
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
    "aarch64-darwin" = "sha256-hQ6j3RmIF1es5AMaSEBC8eVcQKdlHantTBC/Uy+LF9s=";
    "x86_64-darwin" = "sha256-KGhZAAURbDpuexXLrwqeDc4bHCspOy7P05OvUTzHEZ8=";
    "aarch64-linux" = "sha256-qmVnlCCoE9hpOHrcuFPuKLLqoUmIzQXrTfFZXoOhaDk=";
    "x86_64-linux" = "sha256-6twwCYGWoKISmIpepNGT54ZB4XtFnkJ13ddnUXVEm0Q=";
  };
}
