{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.20.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-bcXmQQRZVP8iAiiWrenmKNd4C2+Tsq02kLc2defcgjM=";
  hashes = {
    "x86_64-linux" = "sha256-F21xCDHiHu9eSVb96pYSLoAVeKcYTgSm6Q/adEXaWOI=";
    "aarch64-linux" = "sha256-Vxzx/XLfsyXyhWgz3zMgd5XbV7cOysfbgix/c416Wcg=";
    "aarch64-darwin" = "sha256-h7sF17pUzPnbbBzNXcikKz0RuKQ3rT/Ya7tdjcY2H0Y=";
  };
}
