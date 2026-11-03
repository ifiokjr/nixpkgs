{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.2.6";

  # Upstream Linux binaries are statically linked against musl; the Rust
  # target triple is standard everywhere else.
  platformSuffix =
    if stdenv.hostPlatform.isLinux then
      builtins.replaceStrings [ "gnu" ] [ "musl" ] stdenv.hostPlatform.rust.rustcTarget
    else
      stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-zw49bFQq/ENT3dJ9mY8ynyTlVuFzIUOc8quUHV1o/+M=";
    "x86_64-apple-darwin" = "sha256-gfN3zC1peCaXsWAsbISpF+rEtS/vmUPM4j4Cl1updNc=";
    "aarch64-unknown-linux-musl" = "sha256-F6v9PAnwqeHvaNVLk8t4/5fNSRlApPVUyGzUInKxZpo=";
    "x86_64-unknown-linux-musl" = "sha256-di0R+MJXZShlsM3TWfgSVAzSwC76k+DlaOq6IYUulXo=";
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
