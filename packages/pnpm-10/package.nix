{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-10";
  version = "10.33.4";
  hashes = {
    "x86_64-linux" = "sha256-TRkzD6M0+wEMO3xVJGQV7SPFP9Jg9J0ebZdy82JNJS0=";
    "aarch64-linux" = "sha256-Rx+tM7oXK+iZvFyF0/in7vkj7byAsYBltAJN4u7f8/0=";
    "x86_64-darwin" = "sha256-O6VhPBCkI9dNPKKbrUneHkUVvIbqeiZlKAQr2ofF6kk=";
    "aarch64-darwin" = "sha256-sPShf6DTsqgEpt6AeyDfZhu06Pehvm0ldSvV6F84+nI=";
  };
}
