{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdt";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ifiokjr";
    repo = "mdt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nUTrlD4g6/ZPqVVDnqIALUvUzstCsiV5Xyxy4oVhHTQ=";
  };

  cargoHash = "sha256-MquG3JgJ5pCgj71WxL9Dw2fqXe/OQGUy8ATfqU4/fm8=";

  buildAndTestSubdir = "mdt_cli";

  doCheck = false;

  meta = {
    description = "CLI that updates markdown content anywhere using comments as template tags";
    homepage = "https://github.com/ifiokjr/mdt";
    license = lib.licenses.unlicense;
    mainProgram = "mdt";
  };
})
