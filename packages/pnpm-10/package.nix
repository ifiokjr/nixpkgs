{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-10";
  version = "10.34.8";
  hashes = {
    "x86_64-linux" = "sha256-AfdK04z6Yc1KikUU61MaQhRuy8FWY5OXy3rQP0Y6g90=";
    "aarch64-linux" = "sha256-MGe+K9UJQf69kry1xpWF2WENRUwjwaKjauO+5ZltveU=";
    "x86_64-darwin" = "sha256-FGmAy++RlynsE9xMpwtLQPMGzCwD1tPMgbO30m4ywmg=";
    "aarch64-darwin" = "sha256-5UhQ/kmcN2+q8UaR+Y/ZLxweoppdut8T2QVAm2O0Wxk=";
  };
}
