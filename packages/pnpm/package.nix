{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.23.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-iuta0rfnH8P4H1cvsxB0SfwO+Km+TkzfUdnUmSkhu1E=";
    "aarch64-linux" = "sha256-mGgH47qvYxC3cPO9RW6/bclfRp1CxhDA30qaPX+E1Jg=";
    "x86_64-darwin" = "sha256-svI8RnQw2A1QIqwAeiscj3the7gHElwJ8m3fuvJl2iI=";
    "aarch64-darwin" = "sha256-y4SnwcBYtd4FDXB3Bnb5I/mKxXJqtKBhHybmFogZtaA=";
  };
}
