{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.21.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-XoUyJ6T6OHqVz29hQAqD0fx+MWSUPADidfh1a3WTneI=";
    "aarch64-linux" = "sha256-Byb5jAnw8P5vuR43bE0+d5OlRMHx7D4guq6yu5HEfh8=";
    "x86_64-darwin" = "sha256-HgBNdOV+pUJwpMMDrzopzq6nv2IhmLr8KrY3Z58LBy8=";
    "aarch64-darwin" = "sha256-uuPHJCCkM6NHtfH+GzfDMJyZxLtyIpphbYzgJraODjY=";
  };
}
