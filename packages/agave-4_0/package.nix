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
  version = "4.0.3";

  hashes = {
    "aarch64-apple-darwin" = "sha256-QVuX+s/USf7QajNwJzHLdVQ/BJHqd4E7AHpMS4+CXmE=";
    "x86_64-apple-darwin" = "sha256-7+XtRmZg800VdJot6T/Csv0/TWSFNr6GV9Udp/ZLd1s=";
    "x86_64-unknown-linux-gnu" = "sha256-UKbtBHTJWOHOP7opj0X8HNMRfbXF3yU8wMfYyCfoE6g=";
  };
  platformToolsVersion = "v1.53";

  platformToolsHashes = {
    "aarch64-apple-darwin" = "sha256-I5vFF/RzIN0bCg01URyktm9xZ5x5oKa6+XjDuDia0js=";
    "x86_64-apple-darwin" = "sha256-RucOgyBjLiGfbfr3Ke87z1tP9mr+orLTlKAVkSnlXVk=";
    "x86_64-unknown-linux-gnu" = "sha256-h2tcKUo41B1AvtRZKREJHpLMPzmd0XoPnKyHsd+asSA=";
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
    platformToolsVersion
    platformToolsHashes
    ;
  pname = "agave-4_0";
}
