{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.10.1";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-Y2q8gSIaA7lPDDYr678AB9/Ol3ImrVKQr+0f2qUyCqQ=";
    "aarch64-linux" = "sha256-RQJsx5qMXQbGBKSmJBmM+W/K19mrlgyakkAaDJfJM4g=";
    "x86_64-darwin" = "sha256-I0HyjA3RAsDX+nvpnsqHW5tQtSuKlrk4UzcLO/BCnqU=";
    "aarch64-darwin" = "sha256-cGy4zmp9sZkK2sgrvuhzNoFjyvGpc5iFPlfLQNv0pIg=";
  };
}
