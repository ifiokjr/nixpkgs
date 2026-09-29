{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.28.2";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-a2Wvd4q2tUEzwUv0zaFTc8p9l5mteJxlMgJcozZgidE=";
  hashes = {
    "x86_64-linux" = "sha256-QU/YjRVCHjiREY9tFrqWRBLuxZnc+bS9WHkQzArcsF8=";
    "aarch64-linux" = "sha256-2KB8FEkYJ08altg4m1mmkGzdTZhO3P/x2beiyRFPD6s=";
    "aarch64-darwin" = "sha256-OFEZy92/OdJtSwd3jT4j1cWQOOHIea2dUZpGlJ5ZYiE=";
  };
}
