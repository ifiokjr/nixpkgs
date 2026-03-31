{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pina";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "pina-rs";
    repo = "pina";
    rev = "v${finalAttrs.version}";
    hash = "sha256-srg1y6XwjNjr75tVOtb7vM8HIInzk6ka0+Vn88mqZwM=";
  };

  cargoHash = "sha256-sx5X/VqOOcMmHiBTVDK/J4kFlMwQCWptyPdm4AydywM=";

  buildAndTestSubdir = "crates/pina_cli";

  doCheck = false;

  meta = {
    description = "CLI for Pina, a performant Solana smart contract framework";
    homepage = "https://pina.rs";
    license = lib.licenses.asl20;
    mainProgram = "pina";
    tags = [
      "cli"
      "dev-tool"
      "solana"
    ];
  };
})
