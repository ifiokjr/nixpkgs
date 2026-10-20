{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.25.1-pre";
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
    "aarch64-darwin" = "sha256-tl5u8LThZDePUqx1NIDM5iX6Ze5wIIhp+v4kfRHm9bw=";
    "x86_64-darwin" = "sha256-kLlZ5AZ9kegHWRUP3lw5YH0ZiXdcmYy8QR/WLdz97HU=";
    "aarch64-linux" = "sha256-KWH7dJTyWTB8g4xg8OOLhTkU0urfC4W3HQWhKeKrolw=";
    "x86_64-linux" = "sha256-CqNeU2YL+nv/toD0M7D3jlf5GIF8YV+mws4ympAoN7c=";
  };
}
