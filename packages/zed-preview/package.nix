{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
}:

let
  version = "1.25.0-pre";
in
import ../zed/package.nix {
  inherit
    stdenv
    fetchurl
    lib
    undmg
    makeWrapper
    ;
  channel = "preview";
  overrideVersion = version;
  zedHashes = {
    "aarch64-darwin" = "sha256-qK/X9P14NP0JGja8gG7sSQvIyFVh+JYNCI4UA1Jc8Vs=";
    "x86_64-darwin" = "sha256-/zIBxW0unJQpf2zS2qxJAvdgAmt1aHxRwZMnnrLvioY=";
    "aarch64-linux" = "sha256-gpB5VG2XJs1Fi+voijeLQpcWJNwjjjRmMv0PLKBrNxE=";
    "x86_64-linux" = "sha256-FaWik5MefgK8CfZzgz6TT/CkKh28FvKeiUuCN0QFhVk=";
  };
}
