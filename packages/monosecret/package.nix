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
  version = "0.3.2";
in
rustPlatform.buildRustPackage {
  pname = "monosecret";
  inherit version;

  src = fetchFromGitHub {
    owner = "ifiokjr";
    repo = "monosecret";
    rev = "v0.3.2";
    hash = "sha256-bwBppqpybtQoBeLw6/SVvzCJ20b6laEHk609x6wUyt4=";
  };

  cargoHash = "sha256-QNkU62KqPq1ebaxHt4k5y4ZHe1mMCD/0Bfp03ypUsVI=";

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
