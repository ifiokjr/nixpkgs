{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  zlib,
  lib,
}:

let
  version = "0.67.0";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-f9C3ETCqN70eNG66Z1qtCem2bks4P3B/xlczDOsp7uw=";
    "x86_64-apple-darwin" = "sha256-45TD2UDtnfT2fvU4jFYS8b9j5nFnCxk4RNa1nJJUS8k=";
    "aarch64-unknown-linux-gnu" = "sha256-l0Eo9E3UNhigbSHl/m2f9nGI3lmG/gvFe1NLDkY577k=";
    "x86_64-unknown-linux-gnu" = "sha256-O196/TtRYD7nINt7wbxP5GtaT1022q2ZOcS0xli1GsA=";
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
