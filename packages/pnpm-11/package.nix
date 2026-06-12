{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.6.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-CVkZfxWXvwgxBlFlyZTTnJaA1AAaS4fYA8obIpaOPxQ=";
  hashes = {
    "x86_64-linux" = "sha256-eVI9h+Q/t2XMGjQakkcPNfK9C5ib2CitdwVoj01+mkw=";
    "aarch64-linux" = "sha256-Hn3JIjms37T2dmsyLtC67SfOMVTz8vDYNt5qy3CEJ04=";
    "aarch64-darwin" = "sha256-rRPD+IVZM8QzELn0ZJVIDk1HijXqQrh8w2i6GGYKkec=";
  };
}
