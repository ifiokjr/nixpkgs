{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.8.1";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-gXilWB2xadmRP9b5GJM7FBzWp2Cqt1o8HyXjaj/xtdg=";
    "aarch64-linux" = "sha256-U4Uz2O3CGddVVeQ2y7gcIa2JN0l41FbsprzUTHRq+tw=";
    "x86_64-darwin" = "sha256-Mg0n6ASipcscu5aVh7bRqdxMO5ihZ8T2Yckt9XAgsj0=";
    "aarch64-darwin" = "sha256-XQm0TyZwHSA4JsZCICNkpHzlF+YhUmLE2sVK9Rza6I4=";
  };
}
