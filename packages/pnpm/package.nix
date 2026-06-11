{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.5.3";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-XYNwlW7zFMGXpHVCaKHsyCkMWLuq2RGw/8P7d+mlhWk=";
  hashes = {
    "x86_64-linux" = "sha256-LYrXbOB19GapRT57ruxQKNIvdAP5CrplSOYE6wx9iYg=";
    "aarch64-linux" = "sha256-/k1pHEaZDnaWJgY/m/2IxKomfYscSi2v9Dp0nBlHz1I=";
    "aarch64-darwin" = "sha256-CYMNunTOqGDIAD6FIo07mTKw3otEENDR+o4KBvkyhz8=";
  };
}
