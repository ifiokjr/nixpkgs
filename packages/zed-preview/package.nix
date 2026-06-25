{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.9.0-pre";
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
    "aarch64-darwin" = "sha256-mjhjfKvquXL93Zjfcn/VhZT1J2IXx+Xl3FJjYn/BhLY=";
    "x86_64-darwin" = "sha256-XTJctVe/xkqNML7O0g+vCONz/ItjCFwMbu/uN2dAuls=";
    "aarch64-linux" = "sha256-iUNwU5YvEx4fv96KHBBqWvz0dihjF4mFoFvD+XrxNtc=";
    "x86_64-linux" = "sha256-bUnhWHz9jME0RAgseSwq8l2MVGnFuL/BFQMk3Od6Cbk=";
  };
}
