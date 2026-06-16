{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.7.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-BCQSfBCIjhfruzz8C+aFsqhwecp7w3K+wANjE+PxtNU=";
  hashes = {
    "x86_64-linux" = "sha256-kKb0StRfnOuBXOY8VVaL0Us3AkfDlLl/Z2fvWQNqyg4=";
    "aarch64-linux" = "sha256-sZbUSvQq4mMItcoUUJHtL+vVaeZZDpBv5UoiMiLhw0g=";
    "aarch64-darwin" = "sha256-fT4V9O9Sx1J4noNCEXd9mi1Vv6kNVSLU21WIYnEieFo=";
  };
}
