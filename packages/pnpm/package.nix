{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.6.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-K19imGsU8okft45bVU5g448lmHIX/tV48DA7v9peEko=";
    "aarch64-linux" = "sha256-IriG4oBXkXGqd+LfaZeSkyzPZrGFOqc88c2FHJWUZaw=";
    "x86_64-darwin" = "sha256-G8pZ1TxqrYE9Nipx7q2T4c6tieNDng/ngBGcCIlur8k=";
    "aarch64-darwin" = "sha256-0QnxssVtrJSXimrXvNvhiAnR9DmA8VzurvKHW0aMC3g=";
  };
}
