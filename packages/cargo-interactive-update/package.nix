{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  curl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-interactive-update";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "benjeau";
    repo = "cargo-interactive-update";
    rev = finalAttrs.version;
    hash = "sha256-9SJRDuAXeMYis8k47Eayongadfa1NP/j9Ku311zVBuY=";
  };

  cargoHash = "sha256-J9j4+JlsTnVXly9Y/cLYZlAWBZaHy9p7oWP0ciRy0Q8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ curl ];

  doCheck = false;

  meta = {
    description = "A cargo extension to update direct dependencies interactively";
    homepage = "https://github.com/benjeau/cargo-interactive-update";
    license = lib.licenses.mit;
    mainProgram = "cargo-interactive-update";
  };
})
