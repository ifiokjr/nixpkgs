{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.20.0-pre";
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
    "aarch64-darwin" = "sha256-ZYMXM1aANBDvIZ2yjUN4YAuYEYIYQ4BDumhc3B0nSdM=";
    "x86_64-darwin" = "sha256-LnQbqW1jn0AbYojyq9m5UDNTW1SZmeM5ZEvIXmdjg4s=";
    "aarch64-linux" = "sha256-delaaOn5XhVBkDg8S3xL1AvYiKdh2zvqTz9YrRk6BOw=";
    "x86_64-linux" = "sha256-iJVtNWKRGlHxPxqR03D/iZYiVBzehSFrqHRrTZrPQ6w=";
  };
}
