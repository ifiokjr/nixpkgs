{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.16.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-BV5wShFyx2ZXcioAvsIo6u1VxWASH3PovTKXO8d5NnY=";
  hashes = {
    "x86_64-linux" = "sha256-EjQKRnxDTtXWNgz44Yx06eacowvttmT5U3TqIPSwCE0=";
    "aarch64-linux" = "sha256-CwBw3Q+uBTD4XYfN5DW2z6EmJ4CrW91T5wfxLqWm2jk=";
    "aarch64-darwin" = "sha256-o6OZRNlhvgY7qHT7RTofI8b+Fzt52N7WQLbz90YFaug=";
  };
}
