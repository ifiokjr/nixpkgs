{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.8.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-XeBpD8NoiT0lVyxc+cBBRL7hUC+wlOeA1drONej+NYk=";
  hashes = {
    "x86_64-linux" = "sha256-GkaVzB3xQV84QjYOBenaXWy5NCaPv+HFJC+EUWy4i+k=";
    "aarch64-linux" = "sha256-CWPerw7K1F3E1qDl4sSn3IQZofHYrkDLVIADrHJjqEc=";
    "aarch64-darwin" = "sha256-CBt84IK+Nhb6jsBmIFyy8KcC/hWb+P3SVBOtkiIIKCM=";
  };
}
