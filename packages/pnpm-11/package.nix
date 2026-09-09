{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.26.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-ykMuI1PS23bmtCesDzsTeLEYhZKnh7ePhnrY7pl23sA=";
  hashes = {
    "x86_64-linux" = "sha256-3J+I3r3dXzbt7WARHs1VBZAuYAuyuFIiayWWNqE6r4o=";
    "aarch64-linux" = "sha256-u5LaeSEghRCFO2MvCEeM+KbdOppCH9hEwMG80J/McGw=";
    "aarch64-darwin" = "sha256-4pfYVSBFZfwcbfV1z13bf5tkq9f+3TslhyWGIJihyJM=";
  };
}
