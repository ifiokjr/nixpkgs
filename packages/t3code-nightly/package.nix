{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261015.3145";
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
    "darwin-arm64" = "sha256-jwZSfzWkcW+/q03l8U7t++j7JAADLoL6g0vQAIEwR9E=";
    "linux-arm64" = "sha256-qtTOjEA89ep7WZ4kq6Cbn9Btv5QoMUY39MhVaDLmkmk=";
    "linux-x64" = "sha256-Qdu5P99rkLN+nDKbL6JU0AYb4HWjC3ZQEigdR1xua2U=";
  };
}
