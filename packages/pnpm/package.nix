{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.11.2";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-eQCNMTCEXuig/kOB5rgYFegOG9QRcC80chscxj5uIL8=";
    "aarch64-linux" = "sha256-ybXRoqJU9Fk6b72Hi7u8gdzk+zaxyFDMjzEDHbsI/9s=";
    "x86_64-darwin" = "sha256-1w65mZ5EeTO3f91eGLCqkz8JHqXmhwEfNigSCaGAzH8=";
    "aarch64-darwin" = "sha256-ckZKlKe88ewsMzCqTxkNLqd1AxiPLNhBbrCYsrX8j6A=";
  };
}
