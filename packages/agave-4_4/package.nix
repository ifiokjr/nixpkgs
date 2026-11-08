{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  cargo,
  rustc,
  rustup,
  lib,
  zlib,
  openssl,
  udev,
}:

let
  version = "4.4.1";

  hashes = {
    "aarch64-apple-darwin" = "sha256-5g1mRol39qW18XUj6joYRuzs+nzGV++gua8nm9WNs2k=";
    "x86_64-apple-darwin" = "sha256-KuhH0yDUvnwqcyx4IeVw95J8ra84X7lLKFOEHA1qWxg=";
    "x86_64-unknown-linux-gnu" = "sha256-Ww8Px+Tu2s4F9kVd4Aqh8vPRZCBo8ejVB2C6SREsOUE=";
  };
  # Must match the platform-tools version pinned by this release's
  # cargo-build-sbf (as reported by `cargo-build-sbf --version`). The wrapper
  # installs the bundled SDK under ~/.cache/solana/<version>/ using the
  # version the tool itself reports, so any mismatch leaves the expected
  # cache directory stale and breaks the install check.
  platformToolsVersion = "v1.57";

  platformToolsHashes = {
    "aarch64-apple-darwin" = "sha256-SMMsLsOsNym1yvH91sQUVJYSXt8EOyZisFhr+8kys0o=";
    "x86_64-apple-darwin" = "sha256-5vYjGxSeZK1swSYF0PmTQFzlWGKqREBsAjVjFZ+MPK8=";
    "x86_64-unknown-linux-gnu" = "sha256-sPevEErfcm//KmoJ6i6y8tKWXJIpX01ziMCNFA4MKwA=";
  };
in
import ../agave/common.nix {
  inherit
    stdenv
    fetchurl
    autoPatchelfHook
    makeWrapper
    cargo
    rustc
    rustup
    lib
    zlib
    openssl
    udev
    version
    hashes
    platformToolsVersion
    platformToolsHashes
    ;
  pname = "agave-4_4";
  mirrorBase = "https://github.com/ifiokjr/nixpkgs/releases/download/mirror";
}
