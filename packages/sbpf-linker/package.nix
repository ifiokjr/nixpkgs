{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.2.5";

  # Upstream Linux binaries are statically linked against musl; the Rust
  # target triple is standard everywhere else.
  platformSuffix =
    if stdenv.hostPlatform.isLinux then
      builtins.replaceStrings [ "gnu" ] [ "musl" ] stdenv.hostPlatform.rust.rustcTarget
    else
      stdenv.hostPlatform.rust.rustcTarget;

  hashes = {
    "aarch64-apple-darwin" = "sha256-getrBEnEBBWM4bl3wQxRgZjHvQjbmaniyYrD9Iws9gs=";
    "x86_64-apple-darwin" = "sha256-Gczmmk+6i/3xRdqfHkO5KUeaB0V9d4gjLSD7rzSGlc8=";
    "aarch64-unknown-linux-musl" = "sha256-oQeHncAqKZs8RHvyOY/KiZYBMS9nURD/xhqmyO5ORt4=";
    "x86_64-unknown-linux-musl" = "sha256-17jaWEGa1Ho4vnUdyW/WHfpvL9pUMSZhOmdpiNG8+68=";
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
