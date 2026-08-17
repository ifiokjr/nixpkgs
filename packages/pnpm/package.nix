{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.22.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-mDDoHNt7+CbKp/mcOkM0no0m9wnslzPxABPf62HCa9U=";
  hashes = {
    "x86_64-linux" = "sha256-vTGkmJxE94m/PDi+odd796hhS9E00fXATFBpR8lqxZQ=";
    "aarch64-linux" = "sha256-Goq4TDmEgNb9LjrC+2dAhF+1U+/NtDlduRNlOwiCUEY=";
    "aarch64-darwin" = "sha256-8pW8liAlI6d0eYqTUJr1qMPMHu7RakbOl2vEuahm3hI=";
  };
}
