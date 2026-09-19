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
  # devenv 2.2.2 vendors libghostty-vt-sys bindings that call
  # ghostty_terminal_mode_get(), which nixpkgs' current libghostty-vt
  # (0.1.0-unstable-2026-08-06) no longer exports — it was replaced by the
  # generic ghostty_terminal_get() + GHOSTTY_TERMINAL_DATA_MODE path. Linking
  # then fails with "Undefined symbols ... _ghostty_terminal_mode_get". Pin the
  # last library revision that still exports it; see libghostty-vt/package.nix
  # for when this can be dropped.
  extraBuildInputs = [ (callPackage ./libghostty-vt/package.nix { }) ];
}
