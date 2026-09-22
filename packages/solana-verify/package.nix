{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
}:

let
  version = "0.5.2";

  platformSuffix =
    {
      "aarch64-darwin" = "macos";
      "x86_64-linux" = "linux";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "linux" = "sha256-udXMzpY03BQmnKs+elhkm8FBszBudzWpRHjJNjQfIR8=";
    "macos" = "sha256-VABO7z04NoUkow0Dvk0H6gkqpdwUeCLOy3iK3ME7s64=";
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
