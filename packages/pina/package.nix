{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pina";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "pina-rs";
    repo = "pina";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k+gnn8QwzgCqVNuSAPdfdmceOa8pjYhhtS6UY0KA7Ns=";
  };

  cargoHash = "sha256-oROqXsn3ZYTUlsEEU0yqAnuylWBld2LXnwhJQIX4M/M=";

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
