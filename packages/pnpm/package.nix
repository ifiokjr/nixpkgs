{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "11.14.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  exeHash = "sha256-zBcKx1Xc44P8CC37G1mMrDEG65xLV1NQBcNZNwniZyY=";
  hashes = {
    "x86_64-linux" = "sha256-JlXZ/dGcpKRcq2XiqTmR5myl2cQYAADshjI4aKngXNA=";
    "aarch64-linux" = "sha256-pJZoWSJrv5FyAX5V5EISlx2hgMMOeTJ0mbNdoG7usyg=";
    "aarch64-darwin" = "sha256-klKmVueRq+wMn7Z/UwjALk5evzRjMe63aPX/EZM8Iw4=";
  };
}
