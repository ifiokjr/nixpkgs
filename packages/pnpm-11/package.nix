{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.17.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-y0JTuE7phY9fT+2cYPGpCpT718l7Rr01OG62DyF0G0w=";
  hashes = {
    "x86_64-linux" = "sha256-zHET+aUOca0btJKT1kLJPbSwZedf66ym9Xm17Rqb1eE=";
    "aarch64-linux" = "sha256-1RXkfV9k/wO8Qzc9cMdZOh2xESptWopHQH6qOgDcHTY=";
    "aarch64-darwin" = "sha256-zBe2fexAsSlwOMKKeRyPnrVpFe8HJ/EiPcdIx5WH4vY=";
  };
}
