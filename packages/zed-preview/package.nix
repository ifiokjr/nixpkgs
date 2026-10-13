{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.24.2-pre";
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
    "aarch64-darwin" = "sha256-nATP4imOHrjZdJ9owi40GjGmD0NLL8AQaRZbwXcYUZs=";
    "x86_64-darwin" = "sha256-sgMXSmpUTV75W/xDVkUV5iRKDmgDBrXDWaiSKChggTY=";
    "aarch64-linux" = "sha256-oU1VGXXbLHUkm/aNE/PlQz+5XqHWmDOx5TGU1umdpAg=";
    "x86_64-linux" = "sha256-t1mqSo6LXzUrmjormQ/eykD6ESQmBC/qYpNU8U24NQ4=";
  };
}
