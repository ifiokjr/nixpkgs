{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.43-nightly.20260924.2187";
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
    "darwin-arm64" = "sha256-nu2C8Ozd/ZPUtOHGUhImgY3ag3psS2spnBb9G/VEyEw=";
    "linux-arm64" = "sha256-/DSwmsbKA3JVe3zzrgUaU4rgXhSJz6WxLj7iLybI4Xo=";
    "linux-x64" = "sha256-0/0RtxUAX8L+F2lO1tgC60EIcqSlAiuF6sw7lH152WU=";
  };
}
