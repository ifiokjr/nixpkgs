{
  callPackage,
  libghostty-vt,
}:
callPackage ../devenv/common.nix {
  version = "2.2.2";
  hash = "sha256-UXA2rr/JNIrbTrhPcmbC2y4Uit8NzeAMZAlUfBQ45uw=";
  cargoHash = "sha256-w7RUfoY2HoPdHQzn+qfTl0StoiJLkCN5UtxXLNAfbrM=";
  devenvNixVersion = "2.34";
  devenvNixRev = "59407321a92f7d34d4a53e38959294007c0bc37a";
  devenvNixHash = "sha256-WcqKvA7f7TGrlDVd69T1UXUqVXJ+wfoRbO+mg5L7/Rc=";
  extraBuildInputs = [ libghostty-vt ];
}
