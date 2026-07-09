{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.11.0-pre";
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
    "aarch64-darwin" = "sha256-tRnxYwsu4koNZn2wSLKrS0kzBFtzUzVJ6YizEN0J4EA=";
    "x86_64-darwin" = "sha256-gRmntwvDJFQy1DsvzMoB/6ybamLciJqNA0p6hDSQyd4=";
    "aarch64-linux" = "sha256-IICCLwwilObxw8NrHyJVCf+fQTSzoZ2/v/aWynBuRbk=";
    "x86_64-linux" = "sha256-8cYSR9yNxzkzHuy1agPyNanY6UvKhSO8joyb3u5DL/o=";
  };
}
