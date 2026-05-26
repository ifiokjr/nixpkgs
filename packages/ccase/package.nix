{
  lib,
  stdenv,
  gcc,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  autoPatchelfHook,
}:

let
  version = "0.5.1";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-fidnJZT741Bgk7mgvWcNHBIpsNlU9hFagpZtAFOzTqo=";
    "x86_64-apple-darwin" = "sha256-uVNTdGeDSm+DISTYdLhAWbTAibSM6uLwq324+4j3G6Q=";
    "aarch64-unknown-linux-gnu" = "sha256-j089M8x4/t81Nf3ZBWR31RkHeSEkLh7ltdL8efCDlkk=";
    "x86_64-unknown-linux-gnu" = "sha256-PvQ0YP8CTVQKQoNzbPYa7Ez2d1c+BajI50JmCGzpd+0=";
  };

  prebuiltHash = hashes.${platformSuffix} or lib.fakeHash;
  hasPrebuilt = prebuiltHash != lib.fakeHash;

  meta = {
    description = "Command line interface to convert strings into any case";
    homepage = "https://github.com/stringcase/ccase";
    license = lib.licenses.mit;
    mainProgram = "ccase";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
    ];
  };

  src = fetchFromGitHub {
    owner = "stringcase";
    repo = "ccase";
    rev = version;
    hash = "sha256-VkykOOMHUsJhfktNRfHx+kvB2331PPhT5pW5bX+kLng=";
  };

  sourceBuild = rustPlatform.buildRustPackage {
    pname = "ccase";
    inherit version src;
    cargoHash = "sha256-gi7CR5UUD+qUQ6wx0XepzyHHq9RH7SnsMXIKV4JoiQg=";
    doCheck = false;
    doInstallCheck = true;
    installCheckPhase = "$out/bin/ccase --help > /dev/null";
    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.fromSource ];
    };
  };

  prebuilt = stdenv.mkDerivation {
    pname = "ccase";
    inherit version;
    src = fetchurl {
      url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/ccase/${version}/ccase-${platformSuffix}.tar.gz";
      hash = prebuiltHash;
    };
    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    buildInputs = lib.optionals stdenv.isLinux [ gcc.cc.cc.lib ];
    nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      tar xzf $src -C $out/bin/
      chmod +x $out/bin/ccase

      runHook postInstall
    '';
    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      $out/bin/ccase --help > /dev/null
      runHook postInstallCheck
    '';
    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };
in
if hasPrebuilt then prebuilt else sourceBuild
