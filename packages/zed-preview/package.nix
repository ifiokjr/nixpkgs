{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.22.0-pre";
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
    "aarch64-darwin" = "sha256-3A92cI6bPuY0gnpy82oMoQJqxA8L5s2czjRigGqO97E=";
    "x86_64-darwin" = "sha256-CQYCdGQqhzcfErjwCUSGlnsn40k+E8gTmJVviVJgmxo=";
    "aarch64-linux" = "sha256-lG7DxbaUJfpIuiRfIa7esveG8lDZaEpoTHxetWILz0M=";
    "x86_64-linux" = "sha256-IPH7UZzogQBRG7CcpMPT3X0ImLTOoK3QP7VZZtsU8zI=";
  };
}
