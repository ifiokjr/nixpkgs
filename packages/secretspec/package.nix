{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  dbus,
  stdenv,
}:

let
  version = "0.10.1";
in
rustPlatform.buildRustPackage {
  pname = "secretspec";
  inherit version;

  src = fetchFromGitHub {
    owner = "ifiokjr";
    repo = "secretspec";
    rev = "aab36b10fa4804085d5d70eb0b6b7e83dec00bc7";
    hash = "sha256-lzdmD1DX+T4BANU8iNWQRq3aO5XWGmFd6lJBuHm02ik=";
  };

  cargoHash = "sha256-xG61bQleJ7gMCSAFM8ThpXi8dGLNDonFNvzrjbvR9YY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isLinux [
    dbus
  ];

  # Only build the CLI binary (not the derive macro crate or examples)
  buildAndTestSubcommand = "secretspec";

  # Keyring tests need system keyring access which doesn't work in the Nix sandbox
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo "Checking secretspec version..."
    $out/bin/secretspec --version

    echo "Checking secretspec help..."
    $out/bin/secretspec --help

    runHook postInstallCheck
  '';

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://secretspec.dev";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "secretspec";
    tags = [
      "cli"
      "dev-tool"
      "rust"
      "secrets"
    ];
  };
}
