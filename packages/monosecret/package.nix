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
  version = "0.4.0";
in
rustPlatform.buildRustPackage {
  pname = "monosecret";
  inherit version;

  src = fetchFromGitHub {
    owner = "ifiokjr";
    repo = "monosecret";
    rev = "v0.4.0";
    hash = "sha256-W+3NOfwb0MFE41jXaOBzXND9mD9fnHtmWHRQxJtsx4A=";
  };

  cargoHash = "sha256-pUgYOZ15nH2gEp/HLN8ROlny+PW9HQ8I5bivE+LrWOI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isLinux [
    dbus
  ];

  # Build only the CLI package. Since 0.3.1 the workspace also contains the
  # php/python/npm/ffi language bindings, whose dependencies (ext-php-rs, napi,
  # pyo3) need interpreters at build time (e.g. ext-php-rs requires a `php`
  # executable to generate bindings). `-p monosecret` compiles the CLI binary
  # plus its internal deps (monosecret_derive) and skips the rest.
  # Note: buildAndTestSubcommand is ignored by the cargo build hook — it only
  # affects `cargo test`, which is disabled here.
  cargoBuildFlags = [
    "-p"
    "monosecret"
  ];

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
