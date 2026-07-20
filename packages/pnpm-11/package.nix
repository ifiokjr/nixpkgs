{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.15.1";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-T2k7/7gcyIq4Fq+caEq8h6fotQUlPtPpuI6GDonp3Fo=";
  hashes = {
    "x86_64-linux" = "sha256-hiZXdU6zIrm4VCdTquLPMSHafK5q7QdcopNze71zYCM=";
    "aarch64-linux" = "sha256-hHCFSt2nFO0rura/FiJFAHjn/Ym5NP7IOWahOCX0kd0=";
    "aarch64-darwin" = "sha256-K6PNQvMlTKA+eBdTRCKYvSRtFXwNWX3eO4yBVmKT1yA=";
  };
}
