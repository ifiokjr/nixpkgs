{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.9.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-xuiK0oD3MAo+398ajQgTk2/wODiazBUxlAMGKpHC19M=";
  hashes = {
    "x86_64-linux" = "sha256-aa9sASpfErRGD44igDaMvhBVGrMoUW/FtmXykrWZEBc=";
    "aarch64-linux" = "sha256-ztSM0bq0E73eVP7mhuqhyYu1DuR6UYyR0d7LXyV4c3s=";
    "aarch64-darwin" = "sha256-G1bnPLfPwNIMZ+Ql0sEZV/S/t4W4CoMCkJJvU1/Tn3I=";
  };
}
