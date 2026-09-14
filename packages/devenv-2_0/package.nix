{
  callPackage,
  fetchpatch,
}:
callPackage ../devenv/common.nix {
  version = "2.0.6";
  hash = "sha256-i1G6n/7Z5fO9RhplzXQSTiLyh1Cs0GhoCoEStFLARtA=";
  cargoHash = "sha256-p5kI7HlG6RVxCCEb/J0L2gh36jkm/atAV98ny3h4vqo=";
  devenvNixVersion = "2.32";
  devenvNixRev = "e127c1c94cefe02d8ca4cca79ef66be4c527510e";
  devenvNixHash = "sha256-MRNVInSmvhKIg3y0UdogQJXe+omvKijGszFtYpd5r9k=";

  devenvNixPatches = [
    # Lowdown 3.0 compatibility; devenv's nix fork (2.32-based) predates
    # the upstream fix.
    (fetchpatch {
      name = "nix-lowdown-3.0-support.patch";
      url = "https://github.com/NixOS/nix/commit/472c35c561bd9e8db1465e0677f1efe2cb88c568.patch";
      hash = "sha256-ZCQgI/euBN8t9rgdCsGRgrcEWG3T5MUc+bQc4tIcHuI=";
    })
  ];

  # Upstream tagged v2.0.6 with Cargo.toml already bumped to 2.0.7
  postPatch = ''
    substituteInPlace Cargo.toml --replace-fail 'version = "2.0.7"' 'version = "2.0.6"'
  '';
}
