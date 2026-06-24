{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.7.1-pre";
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
    "aarch64-darwin" = "sha256-bbz0nDPMWtm6Ft/0vlA3g3tQn7cN7hEz2Wgz82iiAc4=";
    "x86_64-darwin" = "sha256-36bxhO46LOCyYtCELQtJHRkaWdFOdhC2HZh3OxHGN78=";
    "aarch64-linux" = "sha256-DaOUKx55nQqNSgiDJjAWaUPCq3s1ONtAdJnFNPQer7w=";
    "x86_64-linux" = "sha256-lp8fBLT0o7Bw+hctvnmgHeTKvq/4xYfkI0uMpTJNUcA=";
  };
}
