{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.28.13";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-HPCaCP6uZBwNcRru7KDGf/ofi+XcjdfE4jSjL7OGZuU=";
  hashes = {
    "x86_64-linux" = "sha256-/W0eHV1dg0ZYyLh6uLH3mn2aHIaXzHh4r18+BaIv/sc=";
    "aarch64-linux" = "sha256-tpWDRJb3UajaXAqt5z9+jeyuqTKHE4CnczChBZVschc=";
    "aarch64-darwin" = "sha256-zrlk8NbQiI/UvmFvP6St0m4zyVQi4gyn9B0yoXIUxcQ=";
  };
}
