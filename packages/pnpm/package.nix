{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.13.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-86Bm6s76GOZIM1EAWwwwfK5h1NvSHpaRlIqHkJASgQo=";
  hashes = {
    "x86_64-linux" = "sha256-55yb1bgf0ZZF7YkOyl5KIUor7xneniVjabvb5qfRXdQ=";
    "aarch64-linux" = "sha256-ldYJsLlrKicnvk9NPrNbTF/G4lalzucgX9OQl+b8qaY=";
    "aarch64-darwin" = "sha256-rneKF97RCmvmMx9Ox0jfLq7GMLUNQvNkN9JvLhBEc/k=";
  };
}
