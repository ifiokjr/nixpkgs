{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.21.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-5KwBzRTgTVrA2dW2hlL9u06EXtBNagQBK2RQTG2bYiQ=";
  hashes = {
    "x86_64-linux" = "sha256-nraPVSqK62WDOvCCR3ZAT/1k9WE1DHzktcxi6SJiwQk=";
    "aarch64-linux" = "sha256-RlSCGxZ05cmVYYFwDp3/rG2Z/BNNwJdM3tGmWrWyyEs=";
    "aarch64-darwin" = "sha256-lpcwYI5JeD7M5WZw4oaBn4P/jLyZUBhZCAfr4Vw93kE=";
  };
}
