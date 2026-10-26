{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.2.3";

  # Upstream Linux binaries are statically linked against musl; the Rust
  # target triple is standard everywhere else.
  platformSuffix =
    if stdenv.hostPlatform.isLinux then
      builtins.replaceStrings [ "gnu" ] [ "musl" ] stdenv.hostPlatform.rust.rustcTarget
    else
      stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-3pjutM7i+lx7nlIH1SP3/bLC3eTUWFViUAAG+MMjyDg=";
    "x86_64-apple-darwin" = "sha256-1mP98DRITdzyjDnOF46G3IAfIxnnFdDEz7xD3+KeVW0=";
    "aarch64-unknown-linux-musl" = "sha256-BE4lLO7k67ZuRyaGZjtBPesa7WukmFi2pd+SKQs51eg=";
    "x86_64-unknown-linux-musl" = "sha256-qJRQVOYAhrAfmRS65KIlabfM7YdI4ltDxxOF5E7a22E=";
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
