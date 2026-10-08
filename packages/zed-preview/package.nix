{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.24.1-pre";
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
    "aarch64-darwin" = "sha256-DVlE5H5si0mMU/Jo0hQf+cuSY6YyPqZ9YRnVVWufbAo=";
    "x86_64-darwin" = "sha256-OqW8oUvGCdqhY4iSuM++tkvFnc+tYtOIDxgQaU2Fhno=";
    "aarch64-linux" = "sha256-D/x2ULDz96MWrbSMkLRIj1KQYrgVcgJUYdjK/uYRUPw=";
    "x86_64-linux" = "sha256-9VEjHoEKtV3Myf0X8uW8zLlmmRC2iJQWBRxAWDlJcno=";
  };
}
