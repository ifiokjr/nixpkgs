{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.2.2";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-Qwy6M6t5bvm8wWB/qTgvNBDhsbj8RWf4yd+NhA+Yuv8=";
    "x86_64-apple-darwin" = "sha256-KoRjsaiWSWuR110tc79BnqwU+hC/jm/S/qqSMYOS50c=";
    "aarch64-unknown-linux-musl" = "sha256-14NmnJOpmA+IzEP5u5LbS2fp53ed1MjdiGvUBS+FtcQ=";
    "x86_64-unknown-linux-musl" = "sha256-oI2v9mWwlosnpLLAOr6xD9Wm9njOlcG7CNPlO+KmrPs=";
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
