{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-11";
  version = "11.15.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency) — v11";
  exeHash = "sha256-YbReaERSjSle/+XjNgUylfmSbpQcGlpVf41FOrB3+j4=";
  hashes = {
    "x86_64-linux" = "sha256-Rk5fGa3a5bRheH8hJhulKc24jgpExPgeNLckcsPa31U=";
    "aarch64-linux" = "sha256-Ng6Vj0uhp/ZvUImtoVdlJjU2ZmPNIbOp11OhD1+qRrs=";
    "aarch64-darwin" = "sha256-x63HjZ+RLSTYqbObi6G+XgWPTGei97dTQmHzZgMWIyc=";
  };
}
