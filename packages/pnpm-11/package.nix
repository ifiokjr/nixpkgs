{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.28.8";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-7P9qdGuf9oXyYMq3Gn6yHOCea7Hk6WL19hXk/7tznro=";
  hashes = {
    "x86_64-linux" = "sha256-hYUDpKgt8ffRyb9kdbmWGuWCCC1/vxw8UvRh8Q5+kvQ=";
    "aarch64-linux" = "sha256-hlgboj5hcKUHM24YQwSwNnQzVNvV6Lfk1flTwmXYFxg=";
    "aarch64-darwin" = "sha256-IuM1WulNeQoxa5AaMZ4gHuqWzSbZYp26pPApUY6dg9Q=";
  };
}
