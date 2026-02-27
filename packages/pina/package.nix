{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pina";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "pina-rs";
    repo = "pina";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QjEANsV5NMh8d8Te2kMtBHRfrDFjY5QJSCtOSi3/sM8=";
  };

  cargoHash = "sha256-ABSYNwGbIL5UNXqP8klSSPFTmTsMZ0WNtx341iBf0o8=";

  buildAndTestSubdir = "crates/pina_cli";

  doCheck = false;

  meta = {
    description = "CLI for Pina, a performant Solana smart contract framework";
    homepage = "https://pina.rs";
    license = lib.licenses.asl20;
    mainProgram = "pina";
  };
})
