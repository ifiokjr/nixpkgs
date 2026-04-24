{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "10.33.2";
  hashes = {
    "x86_64-linux" = "sha256-wzjNGhmgz9tf/SK/vlBNpZXo0c6unyShRcR5kOaO+jo=";
    "aarch64-linux" = "sha256-jRq0Q4ZqTTZkDsNnFfuQcY3TcctaWd6PD+izwtsnOiI=";
    "x86_64-darwin" = "sha256-zTHC3LSgCx4LwG4rEloiUwFKIpiNfF87TTmZ3jbQm+A=";
    "aarch64-darwin" = "sha256-iwVUZDSoFHxmXJ+X6zg4DAF1IiNP62jfBeC4UoxPCMw=";
  };
}
