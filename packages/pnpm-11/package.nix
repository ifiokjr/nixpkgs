{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.27.1";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-ZJkV0oSkjBkm0GjMNmcGcjpQ4zK54W/0WibzB/1akuk=";
  hashes = {
    "x86_64-linux" = "sha256-eXVOkQ+K0/Tgyti0D26bvf6wnJbNq5wcHYR6jUWR6xU=";
    "aarch64-linux" = "sha256-uH6Gq/cbH/V5x4pgHu2h+HoJiwP6OrMLi80juwDkjXU=";
    "aarch64-darwin" = "sha256-HJlL3sCsYl69bV7w6omJG9h8dPZaJRmH7iXeoRxNQ8c=";
  };
}
