{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  lib,
  zlib,
  openssl,
  udev,
  pname ? "agave",
  version,
  hashes,
}:

let
  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  inherit pname version;

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

    for dir in platform-tools-sdk deps; do
      if [ -d "bin/$dir" ]; then
        cp -r "bin/$dir" $out/bin/
      fi
    done

    find $out/bin/platform-tools-sdk -type f -name '*.sh' -exec chmod +x {} \; 2>/dev/null || true

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
