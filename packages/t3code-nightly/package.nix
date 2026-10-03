{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261003.2623";
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
    "darwin-arm64" = "sha256-LOdCJHKhSGAlq90c8F+MsqaS3Kx2wwik0Mj7woZkf9U=";
    "linux-arm64" = "sha256-dqQkLBszTTS/d/xu4TYTO4ozozPI/F8chxBXuQH5V5U=";
    "linux-x64" = "sha256-Ykw6obeAkoLNMiI6N6qhUB1LCZ2xNkzcCjNpngY2RMM=";
  };
}
