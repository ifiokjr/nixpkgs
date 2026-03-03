{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdt";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ifiokjr";
    repo = "mdt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x31WDYHzD1MOr2CEnCwe43HrEg5clJXJtWiFVKJs2fY=";
  };

  cargoHash = "sha256-rFN5SiYk7qfUF2uJ+PDSmVtVmiAHn7hu1eqApaJN+0Y=";

  buildAndTestSubdir = "mdt_cli";

  doCheck = false;

  meta = {
    description = "CLI that updates markdown content anywhere using comments as template tags";
    homepage = "https://github.com/ifiokjr/mdt";
    license = lib.licenses.unlicense;
    mainProgram = "mdt";
    tags = [
      "cli"
      "dev-tool"
    ];
  };
})
