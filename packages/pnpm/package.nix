{ callPackage }:

callPackage ./common.nix {
  pname = "pnpm";
  version = "12.3.4";
  description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
  hashes = {
    "x86_64-linux" = "sha256-mxyV/EE2AMp1pR6+gzLXAZ3DVo/UGH9aXy30oVbvtlw=";
    "aarch64-linux" = "sha256-q1Nm6VLbwoETQhp8fd/bBMm7ZClYuPU+pVg4VEJr1I0=";
    "x86_64-darwin" = "sha256-3kEPwxUxsbekQMjoDeHPdmPMMp/lMKUjJIIT8bL5bK8=";
    "aarch64-darwin" = "sha256-9UrTZ9ikLa+dhIMOS9akXAlX4OMoekXaCMOguNBOx/c=";
  };
}
