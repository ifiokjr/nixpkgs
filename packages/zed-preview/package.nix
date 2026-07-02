{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.10.0-pre";
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
    "aarch64-darwin" = "sha256-7dixnO2j2+kiYQyllGYDM62W2/U6lhdNqLBxZSrkch8=";
    "x86_64-darwin" = "sha256-P6k5wqvvFdKP5Z/zlN6xUJHq07ybAiIR7i3/r5DuI/Y=";
    "aarch64-linux" = "sha256-C46iDnzMZ0+2TSLHNmYfFdxBsOoKmMj/hX9tyKlEe9Q=";
    "x86_64-linux" = "sha256-LoQANXDZVXOr5yqVj6RHaaSXTwzBRKFPgF+7QXKUTCM=";
  };
}
