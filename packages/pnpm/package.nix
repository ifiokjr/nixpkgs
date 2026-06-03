{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.5.1";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-Wnc0uN5ff/J2/bxVh4Civur20Wc2p29CNjhj5437K/Y=";
  hashes = {
    "x86_64-linux" = "sha256-79Px7Y57i8S3UWXsFywJGWRUxZwzrZp7A5lb8xq2LgU=";
    "aarch64-linux" = "sha256-aDwzi+JZN/ZpoB+NQdDzSHCa+a8G7X65efYddSzALt0=";
    "aarch64-darwin" = "sha256-uQRElX8Z977Jg8PmQyRq/qvUslwbNudrQNV2ueumXCY=";
  };
}
