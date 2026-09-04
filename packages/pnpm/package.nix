{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.25.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-DkbI3tc2Bfhe3RmdymcqlRAthOpdw1E1gqyEWtcEQl0=";
  hashes = {
    "x86_64-linux" = "sha256-GlhiR/TK7zFA4FqekQQcVQI3OM6Pj9lDYy203xxgqNg=";
    "aarch64-linux" = "sha256-W+0Fa39XHe0KShGNO2IPA9PpQgAWnCE/C5BrmvteYDY=";
    "aarch64-darwin" = "sha256-4HJsiKxkrz8Pms8j1hOb3hUgBNmsiQ5uDQmqMmeXep4=";
  };
}
