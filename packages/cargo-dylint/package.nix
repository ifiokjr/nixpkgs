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
  pname = "cargo-dylint";
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

  buildAndTestSubdir = "cargo-dylint";

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
    description = "A cargo extension for running Rust lints from dynamic libraries";
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
