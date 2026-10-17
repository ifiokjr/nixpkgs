{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.14.0";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-HemO0uliEROwiHsGMitGHvud9z2RP8HRUQObELcRekE=";
    "aarch64-linux" = "sha256-58okIk62JqAygo7FhMZ5A60vOJkRuEnQCe1woZ9w2NM=";
    "x86_64-darwin" = "sha256-T+WqbAujAT+K77HMI908VPcnKBS+SwJ1601qmNd2niY=";
    "aarch64-darwin" = "sha256-BhNpIMnMytT2FbsIDgVNmsCG/t/DJJe9h6iSt6RYb28=";
  };
}
