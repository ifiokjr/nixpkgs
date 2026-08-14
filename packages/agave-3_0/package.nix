{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  lib,
  zlib,
  openssl,
  udev,
  zstd,
  ncurses,
  libedit,
  libxml2,
  libffi,
  python3,
}:

let
  version = "3.0.14";

  hashes = {
    "aarch64-apple-darwin" = "sha256-yr0I+n9wTSn4rOZpTgb+rP+9X665Em/IFK9USTNxqHc=";
    "x86_64-apple-darwin" = "sha256-4zhfrarIg0e2p+eAZtYpwivfnGSGi4rTGqdaAhCG2wE=";
    "x86_64-unknown-linux-gnu" = "sha256-ZWFDJUIzFqSPV/HO6qkcp49FFuFl4wWzjAGHPPjGuLQ=";
  };
in
import ../agave/common.nix {
  inherit
    stdenv
    fetchurl
    autoPatchelfHook
    makeWrapper
    lib
    zlib
    openssl
    udev
    zstd
    ncurses
    libedit
    libxml2
    libffi
    python3
    version
    hashes
    ;
  pname = "agave-3_0";
}
