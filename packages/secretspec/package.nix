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
    rev = "4ef1af5";
    hash = "sha256-wPSe6etz/WcHh09vOW7N1b0yb1B9+Qw+/+cb/DKCipw=";
  };

  cargoHash = "sha256-rzWzjAkK0keqFnt3TsXKTrFc0yIWQXiGBy2zIG+k4H4=";

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
