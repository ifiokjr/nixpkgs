{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.12.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-YwEFi+OojFz727BV5Gj0z+5QS5lNhk9gfIOLdqrw9mY=";
  hashes = {
    "x86_64-linux" = "sha256-ePgVrlWGGdlD7PgLw2g+5QTTZ9z3l1uB+G7ji+uobdw=";
    "aarch64-linux" = "sha256-ZOAcQsgqCF4cx6dwvHtB1yARyH+ZogQ4amjkq4c41W8=";
    "aarch64-darwin" = "sha256-wxIao0rN5rOlXw7TXuaIO9h/nwo9TymaYVqKKbY4zjo=";
  };
}
