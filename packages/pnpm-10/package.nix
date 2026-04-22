{ callPackage }:

callPackage ../pnpm/common.nix {
  pname = "pnpm-10";
  version = "10.33.1";
  hashes = {
    "x86_64-linux" = "sha256-+9uj5ENE0sGecT1z0vsxgpT95kAeZDkOpA1C2omdKbA=";
    "aarch64-linux" = "sha256-BS907SSpw+khRnkyCbejTANK3oRswhDbZn57oXGqNsY=";
    "x86_64-darwin" = "sha256-49dmd6B4HT9DlZbsE6Hilc5gNglXGK4TrNfWNOf0iws=";
    "aarch64-darwin" = "sha256-B0DutUJX9spzDAi78IM6vlGva/G+c+Cuyy2SunpbpPs=";
  };
}
