{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.16.0-pre";
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
    "aarch64-darwin" = "sha256-ehJR2EiJgYFRbmE6je407K0fjqh/Mct1mzXMg/WKPHc=";
    "x86_64-darwin" = "sha256-bjtghMhy5vatA2gHvoFKh/UgqDrzAFnr3WE3BiKlDVQ=";
    "aarch64-linux" = "sha256-hwISGBRUgRDW7/vRGY5zXDB5pEjL5jmV9Zq3gutvUsU=";
    "x86_64-linux" = "sha256-GLqv3Rt/H9w+ZruwymdU7vS0UcWlXCUlLK41gRCp9xU=";
  };
}
