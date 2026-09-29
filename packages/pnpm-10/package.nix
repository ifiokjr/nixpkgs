{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-10";
  version = "10.34.6";
  hashes = {
    "x86_64-linux" = "sha256-tiUZ9LgOxJpmdyTgBXqwgfodfet6keJoalAIu9of7cQ=";
    "aarch64-linux" = "sha256-jRrRQyEw01PiiTLFgk1Kxcnu9T+XHmBa0wV+nO3RYac=";
    "x86_64-darwin" = "sha256-3LzNEIINA9mLpNBMjGGamPa8vOUhNv06f1qpur4Tgcg=";
    "aarch64-darwin" = "sha256-EW4vfBXKEYJ3x6crmUuw4fhgHkfC+vJRD7WXtul1/iI=";
  };
}
