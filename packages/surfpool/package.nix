{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
}:

let
  version = "1.6.1";

  platformSuffix =
    {
      "aarch64-darwin" = "darwin-arm64";
      "x86_64-darwin" = "darwin-x64";
      "x86_64-linux" = "linux-x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "darwin-arm64" = "sha256-/KChx17KfMhIuP9w8UHG/G05wRp4F2TUhA4AHqkBcsw=";
    "darwin-x64" = "sha256-ls9hyKxDDx3Nju/x/HTPep2FdSNY1DFqv3Y22FJ/3cw=";
    "linux-x64" = "sha256-ZM/z/WuwC7DVx+3vKRWkkTONFOsZtxMKv5yB7lNX0WU=";
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
