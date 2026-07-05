{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.10.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-cqu0QEI8S08cbkwkvhKuSpyjYMYR4naHD+tgYLqTSTQ=";
  hashes = {
    "x86_64-linux" = "sha256-MtCeu16ikobs3cIMSRBlD1u0nF8zv3SFrDTkHAxoV54=";
    "aarch64-linux" = "sha256-UC/mP9PIF4AI7XXmfU0e6OdeavVLxOK3Ivh6bsQtaR8=";
    "aarch64-darwin" = "sha256-wVEI4qzvWCF9CdY78Jp/Okq8bI3Tv1hPdrVFp3o2oCc=";
  };
}
