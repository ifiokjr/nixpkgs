{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-clean-all";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "dnlmlr";
    repo = "cargo-clean-all";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kSFshEoys0MjON3I70xPb7VEwmK4ne0ZsaLwpRZfhD0=";
  };

  cargoHash = "sha256-CdfqMYOgPIwoh+1Ze6YKq7d4SQHVJ0Ac+JlSQ/6kNZ0=";

  doCheck = false;

  meta = {
    description = "Recursively clean all Cargo projects in a directory that match the selected criteria";
    homepage = "https://github.com/dnlmlr/cargo-clean-all";
    license = lib.licenses.mit;
    mainProgram = "cargo-clean-all";
    tags = [
      "cli"
      "dev-tool"
      "rust"
    ];
  };
})
