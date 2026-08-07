{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.15.0-pre";
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
    "aarch64-darwin" = "sha256-WPf4TWuGIzZkWbozZMAvgn8b1//djLHyy5w2PedZHU0=";
    "x86_64-darwin" = "sha256-C8Ge8Ym/bA+a1HTzRWJO5en5C2YREHZ6gckP1jhgvkw=";
    "aarch64-linux" = "sha256-oHbrYCUge0LVy27vz2PETPpJtIisX6HmpM+6YahaJ08=";
    "x86_64-linux" = "sha256-dXFltMUkOeOWChvITvbUcGzI2uGmXPLVcaPerXS4c9o=";
  };
}
