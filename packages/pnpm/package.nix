{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.5.1";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-yYC8Rj5LHc00qxNsc42YfdIaVZD0tLgtwsitPmBeL38=";
    "aarch64-linux" = "sha256-1riyliVjcs29Ar54t+Gbg4feJSq8+SABeYdmC3bEKeg=";
    "x86_64-darwin" = "sha256-Ovbxf6ZcCCTjMxrKNR/dZzvtwkUWz5prOmVmkyYRl78=";
    "aarch64-darwin" = "sha256-jhh90Jex8W3lAOvUubMjkea4hfcIKhENXzN7DUJFjUE=";
  };
}
