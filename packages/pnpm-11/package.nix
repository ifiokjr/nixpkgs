{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.0.0-rc.5";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11 pre-release";
  exeHash = "sha256-32sQj6NTGLDT7yo3IyCkLXH8IBFeTK93eRKo2cnfBh8=";
  hashes = {
    "x86_64-linux" = "sha256-F6/T9ZJ2bAYTx7kaGhQrIv4X/J2Og5usR6kapD3jg/s=";
    "aarch64-linux" = "sha256-Vl6AynDsiIM/a7E8IpcaVPAZhcxjPZyDRGxn94Nhwdw=";
    "x86_64-darwin" = "sha256-zAnMaIoewR0m7EBz9ECT75PVYmnWAD3SNTlTgBDrvik=";
    "aarch64-darwin" = "sha256-a3PrYbBAndTzispAawU81jKaR6xSaZECdokgA3XS0pE=";
  };
}
