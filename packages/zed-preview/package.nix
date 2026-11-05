{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
  patchelf,
}:

let
  version = "1.28.0-pre";
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
    "aarch64-darwin" = "sha256-yNP/zI/TH+DJDRRek7Paywq+uznXmbDDIy08ICta6b4=";
    "x86_64-darwin" = "sha256-a47qJhATp0HAI6JG51DYV1gAJppcx1qZAtRo5aj8f6k=";
    "aarch64-linux" = "sha256-PgZzlTZvex+959y+9NCCkOdp0UEbZOQUX/iWXn9iBgg=";
    "x86_64-linux" = "sha256-cJHX5Fwb0cqSCr0040Rs76/ea8W/eAwSoybM4YBQpOs=";
  };
}
