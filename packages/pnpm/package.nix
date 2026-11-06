{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.18.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-Z53y7t8Vj2OdttHwDnE9dm0NevxqkxvFFJemJdHhvfc=";
    "aarch64-linux" = "sha256-LjJpMLm2cHEt8ck4SdclyF9riXzfkjnucktYfFDd1bw=";
    "x86_64-darwin" = "sha256-DCf3iXeDg9YXq+wUYpPbithx3hGdF0fGF3wGNj2byP4=";
    "aarch64-darwin" = "sha256-dVYVy1IQUeGCqMHrgEeEZrctBlKyuqNlFcmQidqryC4=";
  };
}
