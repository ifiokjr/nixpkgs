{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.2.2";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-VRMQkItMziFgC0TIPIHcUcchxKFsa+opojlAjXCb9so=";
  hashes = {
    "x86_64-linux" = "sha256-hYRh9JH+qsDsiM0AnYLKIJzNQTNY1j8nwhXuP5qcsx8=";
    "aarch64-linux" = "sha256-0yhd2PhSOyeO3tyrEm6I6qJcR28ivnx+eRvhulr+nOE=";
    "aarch64-darwin" = "sha256-4qkwJGQYHDkoBVIiqCCdBkNAvQdH8mm8umHxbT+63wQ=";
  };
}
