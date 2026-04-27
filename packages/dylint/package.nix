{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dylint";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "dylint";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q06arUQ0p6nWtAbpTGJdW34F9Gg6k2rXqRqkLHGe7Zs=";
  };

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
  };

  cargoBuildFlags = [
    "--package"
    "cargo-dylint"
    "--package"
    "dylint-link"
  ];
  cargoInstallFlags = [
    "--package"
    "cargo-dylint"
    "--package"
    "dylint-link"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  doCheck = false;

  env = {
    LIBGIT2_NO_VENDOR = "1";
  };

  meta = {
    description = "Dylint tools for running Rust lints and building Dylint libraries";
    homepage = "https://github.com/trailofbits/dylint";
    license = [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    mainProgram = "cargo-dylint";
    tags = [
      "cli"
      "dev-tool"
      "rust"
    ];
  };
})
