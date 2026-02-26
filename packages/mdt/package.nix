{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdt";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "ifiokjr";
    repo = "mdt";
    rev = "mdt_cli/v${finalAttrs.version}";
    hash = "sha256-5MNlGJivJ0QNOcUseZlNdgwvxz5ihXhnk2kBAK67Eqw=";
  };

  cargoHash = "sha256-1mnnG/XJlT/FCJwnj0GgllIhIZoZKjj3uKyGrkRnOqg=";

  buildAndTestSubdir = "mdt_cli";

  doCheck = false;

  meta = {
    description = "CLI that updates markdown content anywhere using comments as template tags";
    homepage = "https://github.com/ifiokjr/mdt";
    license = lib.licenses.unlicense;
    mainProgram = "mdt";
  };
})
