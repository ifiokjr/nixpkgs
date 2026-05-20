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
    rev = "3f456cd";
    hash = "sha256-hbaPiC6XR8DZ1UtDM+9hK2PASZZJBtNtfn3NbTpmt4Y=";
  };

  cargoHash = "sha256-XA862VyTcJmVAnW60aZf5FsqUO4QUO2k/6Q8UxJeegY=";

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
