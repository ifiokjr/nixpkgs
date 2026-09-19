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
  version = "4.3.0";

  hashes = {
    "aarch64-apple-darwin" = "sha256-C/vXaaVeMvCh/huS9282DwHuGUdfrPjDHLkPmdzKf+A=";
    "x86_64-apple-darwin" = "sha256-RCTTmUBOxF1VUzxg0LUkt92a3cpxg8ZQt7EzgovPVYw=";
    "x86_64-unknown-linux-gnu" = "sha256-yXKJqKux0O+0l9i1yyhbqr2bf46mZH9dFFxdyP82Eeg=";
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
  pname = "agave-4_3";
}
