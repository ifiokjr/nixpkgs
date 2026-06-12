{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-10";
  version = "10.34.3";
  hashes = {
    "x86_64-linux" = "sha256-mX8ZYZugu+/mqODFgjZ3sm8ENMdIkgmM4V7uUs8Xezs=";
    "aarch64-linux" = "sha256-q51tGvfFDYhqHnRKdXV0pABnFhHBAQ1HH2l+z7/tWiM=";
    "x86_64-darwin" = "sha256-OCTYtYbbmqfWTyQyhKp/wwQBnOTs+p31jh/PnlbS9+o=";
    "aarch64-darwin" = "sha256-AjNuRmc6Z7MfoC3B0Dj2rsM8rrmnSomg3B7BqmzQjg4=";
  };
}
