{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.16.1";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-yenUX3hE0y+HF8TKx8Ua7ipzGM1Wr9leslMSWwnWvDI=";
    "aarch64-linux" = "sha256-KJWqwZ4ksX5w2EylfJNPXfzuIpLGGR/jrGJHBlhrgM0=";
    "x86_64-darwin" = "sha256-RAF5cwDoV9mQlXTXxYgcEc4FaQeOYU99WvQOfRZH+LM=";
    "aarch64-darwin" = "sha256-3Yq9ErMUBtf44BmbOo/Ys+tY/CK3+zMNZq8xfWA5PSU=";
  };
}
