{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.5.2";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-IA8xI0CXLo0+KnG9K4T+D4n4Gi0ns0Z6vcv413hwF8E=";
  hashes = {
    "x86_64-linux" = "sha256-OxTGvuNXzNvRMYWScF9MrZq9wWIRXRq1bFDS3CDpKJU=";
    "aarch64-linux" = "sha256-AwC1m7NrZ9CYHSFy5FYb0sSsxvGB0FjcZbNWaHcxxjk=";
    "aarch64-darwin" = "sha256-gglNyp14RpHYHEkphqAM3YsW1BD90b54ZgIK/7uPCvo=";
  };
}
