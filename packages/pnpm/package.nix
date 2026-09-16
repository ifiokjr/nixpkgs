{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.4.2";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-VFuJ1cYCasM9TCi9PGzDjMBQ1XGzWk5p8TqtSkQa8UI=";
    "aarch64-linux" = "sha256-w7uMq6APMIczsIdtJF4eHzrWVuZgX0+F3YYUVyZ66fI=";
    "x86_64-darwin" = "sha256-E1YkgZsw7srZJlpFrgjeSUfuJZN42Blx33IecoFEVKY=";
    "aarch64-darwin" = "sha256-dOMtVqRk7KHys9v8N622wBfrZEnEVbh76Y5/piDTFa8=";
  };
}
