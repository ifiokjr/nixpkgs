{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.23.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-o8Zav4cpM6/N+dn7RrIhohmQGokgFHyFpU3pNa9xacY=";
  hashes = {
    "x86_64-linux" = "sha256-6ngfM2oKgDMffeMoi7zyJSqtARhcuVSOOacxGuUaAKk=";
    "aarch64-linux" = "sha256-/5iIEYIOhhKJ02YLUkohSw7gNZcbf9hg4RZciGwEqlk=";
    "aarch64-darwin" = "sha256-2PrewUsf9ZmkohyoZmGGz27XpzAIGVWO0Nl/bF2N9Rw=";
  };
}
