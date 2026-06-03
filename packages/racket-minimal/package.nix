{
  stdenv,
  fetchurl,
  lib,
  autoPatchelfHook,
  makeWrapper,
  openssl,
  zlib,
}:

let
  version = "9.2";

  arch = if stdenv.isAarch64 then "aarch64" else "x86_64";
  os = if stdenv.isDarwin then "macosx" else "linux-buster";

  hashes = {
    "aarch64-macosx" = "sha256-V0w17viu96lLdQOaS3pOQCyOtwvSDD45SNShC7q8v7g=";
    "x86_64-macosx" = "sha256-Z0XWSnDTe+Ts8OhZBhZ6BF6qrjumR6JZzTeBzI7ZupU=";
    "aarch64-linux-buster" = "sha256-DlcgiOPV4bUbGY1gK9JTgOF2oDkh4ioCgorT33G90c4=";
    "x86_64-linux-buster" = "sha256-hNLDTAuntPIGtbTwzp6BJ8FTpV9lsNvSvdmx4gkbaCI=";
  };
in
stdenv.mkDerivation {
  pname = "racket-minimal";
  inherit version;

  src = fetchurl {
    url = "https://mirror.racket-lang.org/installers/${version}/racket-minimal-${version}-${arch}-${os}-cs.tgz";
    hash = hashes."${arch}-${os}";
  };

  sourceRoot = "racket";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = lib.optionals stdenv.isLinux [
    openssl
    zlib
  ];

  dontBuild = true;
  dontStrip = true;
  dontFixup = stdenv.isDarwin;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r bin collects etc include lib share $out/
    cp -r man $out/share/ 2>/dev/null || true

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    for bin in racket raco; do
      wrapProgram $out/bin/$bin \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl ]}
    done
  '';

  meta = with lib; {
    description = "Programmable programming language (minimal distribution, pre-built)";
    homepage = "https://racket-lang.org/";
    license = with licenses; [
      asl20
      mit
    ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "racket";
    tags = [
      "cli"
      "dev-tool"
    ];
  };
}
