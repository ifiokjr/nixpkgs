{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "knope";
  version = "0.22.3";

  src = fetchFromGitHub {
    owner = "knope-dev";
    repo = "knope";
    rev = "knope/v${finalAttrs.version}";
    hash = "sha256-Ms9sPMU5MXg/x9QKo2MUmfycI32wAA887Bclb7o2tp8=";
  };

  cargoHash = "sha256-1RTvqje02eQ8zr8u9YH0uY7+j0Y0jJT67CfTsIA4XdQ=";

  buildAndTestSubdir = "crates/knope";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libgit2
    zlib
  ];

  env = {
    LIBGIT2_NO_VENDOR = "1";
  };

  meta = {
    description = "A command line tool for automating common development tasks";
    homepage = "https://knope.tech";
    license = lib.licenses.mit;
    mainProgram = "knope";
  };
})
