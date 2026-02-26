{
  stdenv,
  fetchurl,
  lib,
}:

let
  version = "10.30.2";

  platform = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x64";

  hashes = {
    "macos-arm64" = "sha256-lveWjIJVm6fs0nkXFJH9UF1Xo5+H0jzQ/j0+B4G64xE=";
    "macos-x64" = "sha256-G4SeZQSznCtaiCgIMLpZRY6JJlAgLdFF2DVTlNTflTI=";
    "linux-arm64" = "sha256-vCX8zmwF6lUdeNK3LIW4Bo31afk/3BX39qzAAogCTv8=";
    "linux-x64" = "sha256-jglTYI+qHfMhh+eo/3PiwUiyi1LDhg6b3gwT0I2ji8k=";
  };

  platformKey = "${platform}-${arch}";
in
stdenv.mkDerivation {
  pname = "pnpm-standalone";
  inherit version;

  src = fetchurl {
    url = "https://github.com/pnpm/pnpm/releases/download/v${version}/pnpm-${platformKey}";
    sha256 = hashes.${platformKey} or lib.fakeSha256;
  };

  dontUnpack = true;
  dontBuild = true;

  # The pnpm binary is a vercel/pkg binary with an embedded payload at a
  # hardcoded offset (PAYLOAD_POSITION). It reads itself via /proc/self/exe
  # on Linux. We must:
  # - NOT use a wrapper (breaks /proc/self/exe resolution)
  # - NOT strip (corrupts the embedded payload)
  # - NOT shrink RPATHs (patchelf modifies the binary, breaking the payload)
  # Only patchelf --set-interpreter is safe because it appends new data at
  # the end of the file without shifting existing content, preserving the
  # payload at its hardcoded offset.
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 755 $src $out/bin/pnpm

    ${lib.optionalString stdenv.isLinux ''
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/pnpm
    ''}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo "Checking pnpm version..."
    $out/bin/pnpm --version

    echo "Checking pnpm init works..."
    WORK=$(mktemp -d)
    cd "$WORK"
    $out/bin/pnpm init
    test -f package.json

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
    homepage = "https://pnpm.io/";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ ];
    mainProgram = "pnpm";
  };
}
