{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.18.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-GZ860dqY2j5wqtdxY/GOm+m1bG0EnwpwuZ+0FgLUzls=";
  hashes = {
    "x86_64-linux" = "sha256-p39LY8eZ9YQ/Sn9SPXvI0JmYb0xPrDQ9AqudhPVZyHA=";
    "aarch64-linux" = "sha256-vUhPHEjbu0/epusIByXHRcYDATd1jI/oswJvb01sAkA=";
    "aarch64-darwin" = "sha256-mcUZ3qJCKUWJlEIBA4mE6v5ChEe5PpcTOEepk2dDNXo=";
  };
}
