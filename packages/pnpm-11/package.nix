{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.11.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-XTI+Udnt4N+WUX5XHkVSGNniV5fewWDsbyu9G1YM8u0=";
  hashes = {
    "x86_64-linux" = "sha256-Nb9QZ5iJvYCa5M+iTClmwtShv33PMJ99PL9vQl5ceJA=";
    "aarch64-linux" = "sha256-H+kofO5mmnnyGsFVdtHCBPeFUnB8mQWhHVKSuNBQpKo=";
    "aarch64-darwin" = "sha256-bQmfusUmLNlf8PyiuU6c4y2eBk8yStnoz1X2Z6cJyAE=";
  };
}
