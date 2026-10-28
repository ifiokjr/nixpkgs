{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.28.9";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-jjI4j6OrqjQJDuAWQ2oL+JWa8Xg51hAwFZS+RRi0x54=";
  hashes = {
    "x86_64-linux" = "sha256-Ny851IFby2jdG0DxuSKRZqQqBA4B6GvH5uWLf2UAJwo=";
    "aarch64-linux" = "sha256-nNgVojp5FbX/f1mKWe+AqK6DVIEor84ny8xQVs5TYCs=";
    "aarch64-darwin" = "sha256-MlHBEQKw+2wlL2kT+uYzE3DDFSvtEaq1QOORhZ2O2NY=";
  };
}
