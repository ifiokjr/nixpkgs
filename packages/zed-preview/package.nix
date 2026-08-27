{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.18.0-pre";
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
    "aarch64-darwin" = "sha256-BZg/kMRWA7CKjEWUdLYTuTwUUSkTvTqyJZJ/Zw3+Ajc=";
    "x86_64-darwin" = "sha256-XHD1m1NCnIXEiHjRpJq61Kv0c3ITY7NLcg5Lwk3FJWo=";
    "aarch64-linux" = "sha256-vKzgacuGRHzIy16KUy1gAAXxGFPDqIfrnb1tJkraZd0=";
    "x86_64-linux" = "sha256-u5OabUENqlOBzKs6i37nwBzxRzVgPSOlzok5mYTGDq0=";
  };
}
