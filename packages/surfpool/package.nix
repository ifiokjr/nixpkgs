{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
}:

let
  version = "1.8.0";

  platformSuffix =
    {
      "aarch64-darwin" = "darwin-arm64";
      "x86_64-darwin" = "darwin-x64";
      "x86_64-linux" = "linux-x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "darwin-arm64" = "sha256-xdXsgTPz90RvZDlppB0XK1BxQNC0lpZCaQONS89BCMM=";
    "darwin-x64" = "sha256-ooS3DZLnBswZCmDXVn2ML31GLMAbDslJAqmb9mLccbI=";
    "linux-x64" = "sha256-JDE3PK+URfHn+r+kwasZg4GHkSSEPSBnixbfd8ITn0Y=";
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

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/surfpool --version
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A drop-in replacement for solana-test-validator with mainnet state simulation";
    homepage = "https://github.com/txtx/surfpool";
    license = licenses.asl20;
    platforms = [
      "x86_64-linux"
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
