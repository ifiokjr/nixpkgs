{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.28.6";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-d+NQoBPCFkLPBlITlrQcrzLnnhoeTQYwuLOPqZNTzBM=";
  hashes = {
    "x86_64-linux" = "sha256-JfhX1Qmh/4NQcNEG0sSbbZvlm2DPUaeFxN+1fmr3QN8=";
    "aarch64-linux" = "sha256-1Wqq+DiRiaXgDk4irGVb2qd+avmF1fWY8ZxxPZ51iUQ=";
    "aarch64-darwin" = "sha256-9C/1Py2M+50txxaujZP9PrGlPdGPYwUbgraaiecFLpk=";
  };
}
