{
  callPackage,
  libghostty-vt,
}:
callPackage ../devenv/common.nix {
  version = "2.1.2";
  hash = "sha256-EQnZCy7r4VMO6KDoytxHBa0mFbM1D9g1kaDfs/s0YZA=";
  cargoHash = "sha256-uEwxqnLqCFpyV2NbnfuUyVqKrMeVeQzoGQmElaVeGU8=";
  devenvNixVersion = "2.34";
  devenvNixRev = "42d4b7de21c15f28c568410f4383fa06a8458a40";
  devenvNixHash = "sha256-g2KEBuHpc3a56c+jPcg0+w6LSuIj6f+zzdztLCOyIhc=";
  extraBuildInputs = [ libghostty-vt ];
}
