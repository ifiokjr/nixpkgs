{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.9.1";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-lYHJslcUkfngDIQcsphkzDv5bmb4LVXvW61w+PBtGAg=";
    "aarch64-linux" = "sha256-kFMK/gDGL+/R8J0amwrqBY0o/Qhi7rIjHekVH/o20pE=";
    "x86_64-darwin" = "sha256-AiDVMAMOx29rY6XDeVoAQgFjqIEBL9GNHm6e1y76OfY=";
    "aarch64-darwin" = "sha256-RWMW1M+otQuGIkYT9/TspZHZcLB6svO21HlyRGCEXZQ=";
  };
}
