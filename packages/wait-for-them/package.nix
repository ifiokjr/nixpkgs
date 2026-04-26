{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wait-for-them";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "shenek";
    repo = "wait-for-them";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ckw97tR04Sr5eoRX11dswk3+4RvQrA4rI9gZR5xd54E=";
  };

  cargoHash = "sha256-0ToxCKvjhfz8c6RuWN+DT+9bmfIn9wQomzI9lslDtn4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  doCheck = false;

  meta = {
    description = "Wait until all provided host:port pairs are opened or HTTP URLs return 200";
    homepage = "https://github.com/shenek/wait-for-them";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "wait-for-them";
    tags = [
      "cli"
      "docker"
      "networking"
    ];
  };
})
