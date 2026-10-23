{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.15.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-QC9wRbHgWHrLFULxjTivvMtrq/PHRROU5vs9nwFgxso=";
    "aarch64-linux" = "sha256-gRfWXyjmJ+lJ1fxl1jNCJmMmgmpW+jdDF78T/hFmpQ4=";
    "x86_64-darwin" = "sha256-Iu1Bl9JpIzAMzaYrEqPUsn7QDNeZbN5BaIPGuBNZ7aY=";
    "aarch64-darwin" = "sha256-+rOOR5ASd2+jgQMTvYx+H9OfiD+RXBEcqYARLwaVUV4=";
  };
}
