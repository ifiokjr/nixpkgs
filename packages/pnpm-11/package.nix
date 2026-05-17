{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.0.4";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-Vkf+hpA6Tim8eDSaPhI0Wwn1kUsMH8AAAXH6IBnWYRg=";
  hashes = {
    "x86_64-linux" = "sha256-gdUd4nPY4KVwBxcN6S0V/qBjMT7RBYmYstXWFl/7aKQ=";
    "aarch64-linux" = "sha256-KuOBPaUgoc+eHbFMxQD/EcpoZPnRMT39gHv1zfTzN8M=";
    "x86_64-darwin" = "sha256-WZlaKunniQHKbIqwyA9B4ddYodeyodODZGFSqf3f55o=";
    "aarch64-darwin" = "sha256-tNbvgDQsCbs8D3y5+EE1Adp4wKZiP94AYTXTLBbt9OQ=";
  };
}
