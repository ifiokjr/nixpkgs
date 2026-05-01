{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.0.3";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11 pre-release";
  exeHash = "sha256-NBrv1yQXPwI0k0ANHQD4+YPPqAaGKT7ONFiqB+abqxs=";
  hashes = {
    "x86_64-linux" = "sha256-080QOXHYWQ1qSmIjXEKNuJJRNhM820JJ/ss5VWRUOys=";
    "aarch64-linux" = "sha256-fizGskwrUCSlqS8VI63a7dgmeQlR1sK/ID21dfHAPqE=";
    "x86_64-darwin" = "sha256-++aV+EaJXDtmYfHxHb1xPtUm7aK+g4IUQ/JpTEnRykc=";
    "aarch64-darwin" = "sha256-axjNhsKIq9RpFSpm2IWouIq3byi0xNLaeIcnIgctBow=";
  };
}
