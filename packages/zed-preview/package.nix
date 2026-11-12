{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
  patchelf,
}:

let
  version = "1.29.1-pre";
in
import ../zed/package.nix {
  inherit
    stdenv
    fetchurl
    lib
    undmg
    makeWrapper
    patchelf
    ;
  channel = "preview";
  overrideVersion = version;
  zedHashes = {
    "aarch64-darwin" = "sha256-C9jj8ACnrmKUPmvScy64p9bd0FGfp5t5LT9MH+ylTHo=";
    "x86_64-darwin" = "sha256-NekQ2BcYKlWEotjLF+J+r0NR1oCsgw5X2BoekQuzkSw=";
    "aarch64-linux" = "sha256-Kz0Zm7ZuJSW6Bz/y1Xk1Pbzk8+Sl8tbpHrg7MHQ7ke8=";
    "x86_64-linux" = "sha256-qAb0Bp6eecaCsBXpHZev1LUCyP+Pxu2NG53zUqJIizU=";
  };
}
