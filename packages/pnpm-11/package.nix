{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.0.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11 pre-release";
  exeHash = "sha256-dC2n9YNjUhIsjSeUXeA/vI+wvMuMzARADF1KeRG2nEg=";
  hashes = {
    "x86_64-linux" = "sha256-44VSx+QTWMfNwq4B7U3TlgyWTxOoBOn4d2XbkCyQGds=";
    "aarch64-linux" = "sha256-ur19gaUvuFYm6joZlkazQDk5HgUgvSff4pH344pB30U=";
    "x86_64-darwin" = "sha256-P5KfWs/W6ePBMAi1fQoD8QKXTmNK5fQWWvJZh73ionE=";
    "aarch64-darwin" = "sha256-pyhjK3baFvBDtsUSzjy1gv0FZ5S9ZEjDFaSXRCD7V4k=";
  };
}
