{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "0.0.46-nightly.20261007.2774";
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
    "darwin-arm64" = "sha256-Ufj7yEsfQ2gtME9efdjkppHLWrh9+pFOeVzzLCvk9xk=";
    "linux-arm64" = "sha256-fn0DLMcVpC3xlfrex2C7RmIs5LLNK3sPm2c8222lLbQ=";
    "linux-x64" = "sha256-cFIRPSCxQrEZgaTMYNhpAMQfLM9b+TgAqFrhjGa2yb8=";
  };
}
