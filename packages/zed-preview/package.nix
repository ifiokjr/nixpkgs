{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
  patchelf,
}:

let
  version = "1.30.1-pre";
in
import ../zed/package.nix {
  inherit
    stdenv
    fetchurl
    lib
    undmg
    makeWrapper
    patchelf
    ;
  channel = "preview";
  overrideVersion = version;
  zedHashes = {
    "aarch64-darwin" = "sha256-nmqJ22LHyVdVSqUDhd1I0HkveZE5kKBh5eTapWCUXE4=";
    "x86_64-darwin" = "sha256-ABTcdr6aQL+aD9DuE/7x3rCQ46tIypw2qbwEsgLc6mo=";
    "aarch64-linux" = "sha256-q0AKrkTQ5hxDj5SNIH91Wcgr4H6T2zitRT3W3hxkvCA=";
    "x86_64-linux" = "sha256-U+ZkRO+GNPgVULk3F8RQX7grWznBbO3xGcLhPMbCQZQ=";
  };
}
