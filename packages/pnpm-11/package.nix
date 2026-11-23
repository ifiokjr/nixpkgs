{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.29.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-itujr8ogUWLvEQRGOiNHMbBpxEt56n9Pv/PJ/8B7ZqU=";
  hashes = {
    "x86_64-linux" = "sha256-jmDYCMciWTojTeK7//+K4nSCkh8BGSXzS7GnyK4YohI=";
    "aarch64-linux" = "sha256-5yRXCZcUorJC6eHdGrOmJoT3nZPrCVP2dTHwLoq9p2I=";
    "aarch64-darwin" = "sha256-uiBn13wMAInltfQOsqYB6mDXm7sv0yvzZ3PqM+P0Xdw=";
  };
}
