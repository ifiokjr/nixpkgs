{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.12.0-pre";
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
    "aarch64-darwin" = "sha256-EnHTBcIqsZ8YGMog2fx7YFMChdcfFruMbl5Ui2HFuBc=";
    "x86_64-darwin" = "sha256-rVRfrAj8CV6T9dF21sTBhte+e3Q9/Jp+908cYH/fsNY=";
    "aarch64-linux" = "sha256-rm3yZAPvpCjS3fm+FGMFOJQghwBbln2GnvqbaGHdcao=";
    "x86_64-linux" = "sha256-KqqXibrYxLzt+HInAJla86wbqgVlDE4PKLha6BOflgc=";
  };
}
