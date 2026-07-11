{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-10";
  version = "10.34.5";
  hashes = {
    "x86_64-linux" = "sha256-7t6MGF+eAFYPRS3e+4zZ+sFc7a0IEYAIReiO+ocFRk8=";
    "aarch64-linux" = "sha256-GLtoa0DRvdIBfuzFbKYKLXVFtlemxBRLEF+qiaGJQcM=";
    "x86_64-darwin" = "sha256-Tl9vd5cVtDYdzujXJWagm4M5T9mpsTlEEJ8ZxRXqvic=";
    "aarch64-darwin" = "sha256-8OODAW8IhDvjrh3sB0AUMOh71AvGGlaiQh6nYnbg+cA=";
  };
}
