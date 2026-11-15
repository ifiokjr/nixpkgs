{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.28.12";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-VLBiIQ57+QSDsUaOWyTe3OZkWl6EU8icLRyluHScyFQ=";
  hashes = {
    "x86_64-linux" = "sha256-KZ5+NmEAiKzvdXHP+sgjaJDWiAN+nZwsoRHDDvuCOTw=";
    "aarch64-linux" = "sha256-4iB1NeTkiY9tsuib62KNSCV4vvFovP6wZcFiYlQzIDY=";
    "aarch64-darwin" = "sha256-Ut+0i+65WwCRlvdoOGiTJNOEUcLuRO6uHpptKADXElc=";
  };
}
