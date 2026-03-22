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
  version = "0.22.4";

  src = fetchFromGitHub {
    owner = "knope-dev";
    repo = "knope";
    rev = "knope/v${finalAttrs.version}";
    hash = "sha256-2lZhetmctKSfLXd7jvepm1+Vc0db1teryx6tehEHCJM=";
  };

  cargoHash = "sha256-L7IT7nWinyWiuIwlBmGmHDyKB+o3LJBanHVFRQpWB+c=";

  buildAndTestSubdir = "crates/knope";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libgit2
    zlib
  ];

  doCheck = false;

  env = {
    LIBGIT2_NO_VENDOR = "1";
  };

  meta = {
    description = "A command line tool for automating common development tasks";
    homepage = "https://knope.tech";
    license = lib.licenses.mit;
    mainProgram = "knope";
    tags = [
      "cli"
      "dev-tool"
    ];
  };
})
