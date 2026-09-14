{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.2.1";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-om0yRs6x7PuYdwMO9tucwXasEDqxkJ6JvLGg6yUEo+I=";
    "x86_64-apple-darwin" = "sha256-AMU4rQWMa1xOGsM3MKLxSOPHAN3XxbeOPqc/yn09JV8=";
    "aarch64-unknown-linux-musl" = "sha256-wNa+aMUL0gKUg3LFIX6C6/KWR9LqjX/lnENaufhuSJE=";
    "x86_64-unknown-linux-musl" = "sha256-5qIDAutNN4PCnSYMlFc1WMymPMK4yKqaqZmRqtJiqXU=";
  };
in
stdenv.mkDerivation {
  pname = "sbpf-linker";
  inherit version;

  src = fetchurl {
    url = "https://github.com/blueshift-gg/sbpf-linker/releases/download/v${version}/sbpf-linker-${platformSuffix}.tar.gz";
    hash = hashes.${platformSuffix} or (throw "No prebuilt for platform: ${platformSuffix}");
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    tar xzf $src -C $out/bin/
    chmod +x $out/bin/sbpf-linker

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/sbpf-linker --version | grep -F "${version}"

    runHook postInstallCheck
  '';

  meta = {
    description = "Upstream BPF linker for SBPF V0/V3 programs";
    homepage = "https://github.com/blueshift-gg/sbpf-linker";
    license = lib.licenses.mit;
    mainProgram = "sbpf-linker";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "linker"
      "solana"
      "bpf"
    ];
  };
}
