{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.45-nightly.20260930.2481";
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
    "darwin-arm64" = "sha256-TKWFuaIM0009QyWJ8XD80pipXP/PGNaqBkjTVzL17ZA=";
    "linux-arm64" = "sha256-SwuwDx3R1Sr6CG4/fhPkhDB/uQgU8cS97NCdO5drAUE=";
    "linux-x64" = "sha256-QTaySEr5XCkrs53WCzRBwTK0yVxO1fgbI9hz+ldC4HM=";
  };
}
