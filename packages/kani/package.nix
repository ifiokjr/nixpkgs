{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  zlib,
  lib,
}:

let
  version = "0.68.0";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-pdOaXV50glOlU6pi8pXGw5coeSeijl4yaR1/8u2gw5g=";
    "x86_64-apple-darwin" = "sha256-sTZ/aUwTUKvK4TNwH3izvj/W6b62ZoGiLqC8rAzDSAg=";
    "aarch64-unknown-linux-gnu" = "sha256-AELSaIvxVQJw3vSnnJaq7qE4YxgYy0q1SAEg8tUalCw=";
    "x86_64-unknown-linux-gnu" = "sha256-MuK0hNc+3gu/ZKLPCHnEJZQiSX2K7E7mfUSN6a54Q9M=";
  };
in
stdenv.mkDerivation {
  pname = "kani";
  inherit version;

  src = fetchurl {
    url = "https://github.com/model-checking/kani/releases/download/kani-${version}/kani-${version}-${platformSuffix}.tar.gz";
    hash = hashes.${platformSuffix} or lib.fakeHash;
  };

  sourceRoot = "kani-${version}";
  dontBuild = true;
  dontStrip = true;
  dontFixup = stdenv.isDarwin;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  # librustc_driver is provided at runtime by the rust toolchain that kani
  # setup manages (kani-driver sets LD_LIBRARY_PATH when spawning
  # kani-compiler); it is not shipped in the release bundle.
  autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.isLinux [ "librustc_driver-*.so" ];
  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc.lib
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R ./* $out/

    ln -s $out/bin/kani-driver $out/bin/kani
    ln -s $out/bin/kani-driver $out/bin/cargo-kani

    if [ -d $out/scripts ]; then
      patchShebangs $out/scripts
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Bit-precise model checker for Rust";
    homepage = "https://model-checking.github.io/kani/";
    license = [
      licenses.asl20
      licenses.mit
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "kani";
    tags = [
      "cli"
      "rust"
      "verification"
      "model-checking"
    ];
  };
}
