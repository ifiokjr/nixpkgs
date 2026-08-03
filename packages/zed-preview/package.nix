{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.14.2-pre";
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
    "aarch64-darwin" = "sha256-gizdClXBQ1RWiYkVfNNJ2oDD42vReLhbRKNVPcgpGbQ=";
    "x86_64-darwin" = "sha256-8g1tFsm7EigukSj2NYHqOHwws4czuqkn0exBNBM5oog=";
    "aarch64-linux" = "sha256-M82qUtKfIhmojyFKdlPTeWjKgocdPkxilPW5JuTUa04=";
    "x86_64-linux" = "sha256-7oYucfM0TN74rUyfDAUr6+NhszBrfYveL6skAIqiKbg=";
  };
}
