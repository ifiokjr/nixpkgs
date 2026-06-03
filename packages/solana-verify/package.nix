{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
}:

let
  version = "0.5.0";

  platformSuffix =
    {
      "aarch64-darwin" = "macos";
      "x86_64-linux" = "linux";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "linux" = "sha256-QRx7xM1gAfIVyiGrfeXdIhQBdf72ng5IPEdoAY9lHrY=";
    "macos" = "sha256-fqUP4MoTPjBhS4MEjoqYXOanBZ7oISZ25P9eRqycfCQ=";
  };
in
stdenv.mkDerivation {
  pname = "solana-verify";
  inherit version;

  src = fetchurl {
    url = "https://github.com/solana-foundation/solana-verifiable-build/releases/download/v${version}/solana-verify-${version}-${platformSuffix}";
    hash = hashes.${platformSuffix} or lib.fakeHash;
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = stdenv.isDarwin;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/solana-verify
    chmod +x $out/bin/solana-verify

    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI tool for building verifiable Solana programs";
    homepage = "https://github.com/solana-foundation/solana-verifiable-build";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    maintainers = [ ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "solana-verify";
    tags = [
      "cli"
      "solana"
      "build"
      "verification"
    ];
  };
}
