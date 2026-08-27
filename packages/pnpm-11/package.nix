{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.24.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-afHZXLrS4tUfpWwN2pHnhcacVSjWXRLKDxK6wo2qi68=";
  hashes = {
    "x86_64-linux" = "sha256-Lp73ShzdPXjf55EYEsUMi1f4yrb5FJjHQ40buieqIg0=";
    "aarch64-linux" = "sha256-hEAMDUo76R3xiqEmLqQmcLOqm3CXLDMwKwwS+b6Si3I=";
    "aarch64-darwin" = "sha256-cdQzzauQ9g3/hHh2eRoUCVedU3yU9LFx+nCeAaWigU4=";
  };
}
