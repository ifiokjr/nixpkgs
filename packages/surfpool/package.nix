{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
}:

let
  version = "1.1.0";

  platformSuffix =
    {
      "aarch64-darwin" = "darwin-arm64";
      "x86_64-darwin" = "darwin-x64";
      "x86_64-linux" = "linux-x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "darwin-arm64" = "sha256-BnB8XTi5hQdrgv4I2kA6/ncSiYwz0kh2fESDz2wex7E=";
    "darwin-x64" = "sha256-e7flDzRdfMbTNYkQwOzMWx/x229FJ/4tSduTqzMefVM=";
    "linux-x64" = "sha256-axcqRrWIuX0CtK/tCLX4WnU/iklRz8xEE3KFTTkGJ/E=";
  };
in
stdenv.mkDerivation {
  pname = "surfpool";
  inherit version;

  src = fetchurl {
    url = "https://github.com/txtx/surfpool/releases/download/v${version}/surfpool-${platformSuffix}.tar.gz";
    sha256 = hashes.${platformSuffix} or lib.fakeSha256;
  };

  dontBuild = true;
  dontStrip = stdenv.isDarwin;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp surfpool $out/bin/surfpool
    chmod +x $out/bin/surfpool

    runHook postInstall
  '';

  meta = with lib; {
    description = "A drop-in replacement for solana-test-validator with mainnet state simulation";
    homepage = "https://github.com/txtx/surfpool";
    license = licenses.asl20;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "surfpool";
    tags = [
      "cli"
      "dev-tool"
      "solana"
    ];
  };
}
