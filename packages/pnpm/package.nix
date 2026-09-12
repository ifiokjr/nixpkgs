{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.4.1";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-YU0YvcsSGoRMAmCzFddrc35oc0bAAbjgk/0KkyAsLWs=";
    "aarch64-linux" = "sha256-79UEsfvqNGHdoyIESBE3Q0VXz8HtcKsD8Nxvlt0r6EU=";
    "x86_64-darwin" = "sha256-/4zVEgEpiwOvh/QkJ/w53LcA/w8dZCT6u9CF039RjLQ=";
    "aarch64-darwin" = "sha256-nI4gCXq7OtTzC/oxw+WT016REfuGdaBq1rOR/N17yKA=";
  };
}
