{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.13.1";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-5b2ZbCE9bt0zdSiDsKfkPi5zqnurPykwi2d5nZfQIzo=";
  hashes = {
    "x86_64-linux" = "sha256-fA3FYIRyQrLlQB5QxIdG/MyWOWZNhfLCyXl5wPHDJ4A=";
    "aarch64-linux" = "sha256-/calOcvwapCMlwIOUTD9vZ6T60qSNr18c2QCrjiwLKs=";
    "aarch64-darwin" = "sha256-Bd7954to/3a44/CEiWwrKacNcK6L+oc6PVm46auYlCE=";
  };
}
