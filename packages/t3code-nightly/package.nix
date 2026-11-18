{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.11-nightly.20261118.4877";
in
# Nightly channel of the same self-contained CLI archive. Both packages install
# `bin/t3`, matching the other version tracks in this repo (pnpm-10/pnpm-11,
# melos_6/melos_7/melos_8): install one of them, not both.
import ../t3code/package.nix {
  inherit
    lib
    stdenv
    fetchurl
    autoPatchelfHook
    ;
  channel = "nightly";
  overrideVersion = version;
  t3codeHashes = {
    "darwin-arm64" = "sha256-aPlLOIzT4bRLEXHSvpSLGLzq1LpUX8t8R/4wvgZdmMU=";
    "linux-arm64" = "sha256-RTkzx+hm2r6z9TKP93MXfdyr158RlljPXKUjGZgGOvA=";
    "linux-x64" = "sha256-46TKWqnIP0Gl3R8PfaZb6GbX0sJ7fpq9K1CGv1mH+Dc=";
  };
}
