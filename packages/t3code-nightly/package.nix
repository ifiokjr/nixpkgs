{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.1.13-nightly.20261125.5258";
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
    "darwin-arm64" = "sha256-xugJOwWMVXkFG2GlylfJ1gFp/fqnMN/VyRshQCpGUa4=";
    "linux-arm64" = "sha256-CEBL80xLWUxba7g4q5nZv5Lpf4cLc9RAzqKHLuYkQ1M=";
    "linux-x64" = "sha256-tZrV1qUs3NZ2SCJ3BQNwhMb9Pn/vFD1ptz1vqN+HIXQ=";
  };
}
