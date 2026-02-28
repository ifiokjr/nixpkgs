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
  version = "9.1";

  arch = if stdenv.isAarch64 then "aarch64" else "x86_64";
  os = if stdenv.isDarwin then "macosx" else "linux-buster";

  hashes = {
    "aarch64-macosx" = "sha256-5TtdBh+FXnRUi32LW+pr7GidVNBe2H5IXlNIFsmwlrw=";
    "x86_64-macosx" = "sha256-ih+FNqA2q0yoXrVn6vTs4emOjNQapRvs9L6de7Gyn28=";
    "aarch64-linux-buster" = "sha256-q9KH9RK2Y+2YSGCs+GElO3WVARAdxyhjKAnL/+L6WGE=";
    "x86_64-linux-buster" = "sha256-vVY+O5ZNs0G8QYdYia3aqNh1UuS/YrTlDHVuWm8aPVA=";
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
