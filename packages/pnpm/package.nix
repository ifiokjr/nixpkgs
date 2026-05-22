{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.1.3";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-ZBcNHiw/PAr/nOGB6Yl9cIAFMKR4XTtBTmnJP57JQN8=";
  hashes = {
    "x86_64-linux" = "sha256-S68ERnZxOCdFThw0WSkD7pQn2PEWwybY+ZhijtCQNDM=";
    "aarch64-linux" = "sha256-ZuEe91+e/kBK+i9ja1rBXfSS82ot2uX3NaHZAyD8Dco=";
    "aarch64-darwin" = "sha256-q3REI0Ib8mRTkwmqWqn5fkVBpH6pZm3q1X3BzCiICqE=";
  };
}
