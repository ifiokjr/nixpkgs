{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  lib,
  zlib,
  openssl,
  udev,
}:

let
  version = "3.1.10";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-g5aT1AvdC9dtlWn33z04+zvGmqUCj8YL7zqpSO7kU6U=";
    "x86_64-apple-darwin" = "sha256-cHph7beo0ChVn9HdJ5ZtZ3dK1Ml6Yc1m7DCJ6KB9VCM=";
    "x86_64-unknown-linux-gnu" = "sha256-pyBf8pvPD3GZdAIl7K4rhaKOqWaIktXsIb2XSYgphKE=";
  };
in
stdenv.mkDerivation {
  pname = "agave";
  inherit version;

  src = fetchurl {
    url = "https://github.com/anza-xyz/agave/releases/download/v${version}/solana-release-${platformSuffix}.tar.bz2";
    sha256 = hashes.${platformSuffix} or lib.fakeSha256;
  };

  dontBuild = true;
  dontStrip = stdenv.isDarwin;

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc.lib
    zlib
    openssl
    udev
  ];

  sourceRoot = "solana-release";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    find bin -maxdepth 1 -type f -exec cp {} $out/bin/ \;
    chmod +x $out/bin/*

    # Include the platform tools SDK for cargo-build-sbf / cargo-test-sbf
    if [ -d bin/platform-tools-sdk ]; then
      mkdir -p $out/lib
      cp -r bin/platform-tools-sdk $out/lib/
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Solana validator client and CLI toolchain by Anza";
    homepage = "https://github.com/anza-xyz/agave";
    license = licenses.asl20;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "solana";
    tags = [
      "cli"
      "dev-tool"
      "solana"
    ];
  };
}
