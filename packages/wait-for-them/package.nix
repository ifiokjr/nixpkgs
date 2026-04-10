{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  openssl,
  lib,
}:

let
  version = "0.5.1";

  platformSuffix =
    {
      "x86_64-darwin" = "macos";
      "x86_64-linux" = "linux";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "macos" = "sha256-cBCRMGX4JM75xHNmjTDKKvDuzKlS7+s1a2YF0kFM7ew=";
    "linux" = "sha256-wiGuTSWXvZGUPJ/v1gMGAz1v4eX4OABnko7CXPsAv6A=";
  };
in
stdenv.mkDerivation {
  pname = "wait-for-them";
  inherit version;

  src = fetchurl {
    url = "https://github.com/shenek/wait-for-them/releases/download/v${version}/wait-for-them-${platformSuffix}";
    sha256 = hashes.${platformSuffix} or lib.fakeSha256;
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = stdenv.isDarwin;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc.lib
    openssl
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/wait-for-them
    chmod +x $out/bin/wait-for-them

    runHook postInstall
  '';

  meta = with lib; {
    description = "Wait until all provided host:port pairs are opened or HTTP URLs return 200";
    homepage = "https://github.com/shenek/wait-for-them";
    license = licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = [ ];
    mainProgram = "wait-for-them";
    tags = [
      "cli"
      "docker"
      "networking"
    ];
  };
}
