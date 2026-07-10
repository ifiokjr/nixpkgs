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
  version = "0.1.0";
in
rustPlatform.buildRustPackage {
  pname = "monosecret";
  inherit version;

  src = fetchFromGitHub {
    owner = "ifiokjr";
    repo = "monosecret";
    rev = "v${version}";
    hash = "sha256-TQqqlwoC41LKo8wbS5zHY+y8zOOB+r7vWsullfuRaQc=";
  };

  cargoHash = "sha256-v9p4KiDeRRdsKTjR3z/kHLaOP+foUJfKz+sAUG9fZkQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isLinux [
    dbus
  ];

  # Only build the CLI binary (not the derive macro crate or examples)
  buildAndTestSubcommand = "monosecret";

  # Keyring tests need system keyring access which doesn't work in the Nix sandbox
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo "Checking monosecret version..."
    $out/bin/monosecret --version

    echo "Checking monosecret help..."
    $out/bin/monosecret --help

    runHook postInstallCheck
  '';

  meta = {
    description = "Declarative secrets, every environment, any provider";
    homepage = "https://ifiokjr.github.io/monosecret";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "monosecret";
    tags = [
      "cli"
      "dev-tool"
      "rust"
      "secrets"
    ];
  };
}
