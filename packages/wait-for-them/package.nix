{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.5.1";

  platformSuffix =
    {
      "aarch64-darwin" = "macos";
      "x86_64-darwin" = "macos";
      "aarch64-linux" = "linux";
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
    hash = hashes.${platformSuffix} or lib.fakeHash;
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/wait-for-them
    chmod +x $out/bin/wait-for-them

    runHook postInstall
  '';

  meta = {
    description = "Wait until all provided host:port pairs are opened or HTTP URLs return 200";
    homepage = "https://github.com/shenek/wait-for-them";
    license = lib.licenses.gpl3Only;
    mainProgram = "wait-for-them";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    # Note: upstream provides generic macos/linux binaries (likely x86_64)
    # May need Rosetta on aarch64-darwin or may not work
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "docker"
      "networking"
    ];
  };
}
