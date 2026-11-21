{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
  patchelf,
}:

let
  version = "1.30.2-pre";
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
    "aarch64-darwin" = "sha256-rTJl9Y6LTrmLdbtOOHgTaZldGmMeH3ZB6x9hwpeD/dg=";
    "x86_64-darwin" = "sha256-DTSA1oxDFR4qN0afVoMHYOqmZKb6QzvOv5DqhU6wtR0=";
    "aarch64-linux" = "sha256-hczbfzFCurchGDEmkmvsIIUg6xCSPztlsPim6t/4S/E=";
    "x86_64-linux" = "sha256-FYjhcPu8lF1wYr5+aGPCbCgsgBOdXtF+hFGd/aR9UWA=";
  };
}
