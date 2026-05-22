{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  autoPatchelfHook,
  curl,
}:

let
  version = "0.6.2";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-Op1DTlXfJhyRdunBgiThlmHDg3r/ZqvKz/1klH5C9f8=";
    "x86_64-apple-darwin" = "sha256-NsrJSmcUCr+GyLvs4ZcOe5kRmRDG+AjlXwdCWafTq1g=";
    "aarch64-unknown-linux-gnu" = "sha256-MWenYHJm7JeeKVq8/GCky1YJLoMgJ0XjDWU0xIur4Wc=";
    "x86_64-unknown-linux-gnu" = "sha256-5mi6wSkY7qx5m3Sda0kiOEmlwp4SBF2cB/asw1c3ByY=";
  };

  prebuiltHash = hashes.${platformSuffix} or lib.fakeHash;
  hasPrebuilt = prebuiltHash != lib.fakeHash;

  meta = {
    description = "A cargo extension to update direct dependencies interactively";
    homepage = "https://github.com/benjeau/cargo-interactive-update";
    license = lib.licenses.mit;
    mainProgram = "cargo-interactive-update";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "dev-tool"
    ];
  };

  src = fetchFromGitHub {
    owner = "benjeau";
    repo = "cargo-interactive-update";
    rev = version;
    hash = "sha256-9SJRDuAXeMYis8k47Eayongadfa1NP/j9Ku311zVBuY=";
  };

  sourceBuild = rustPlatform.buildRustPackage {
    pname = "cargo-interactive-update";
    inherit version src;
    cargoHash = "sha256-J9j4+JlsTnVXly9Y/cLYZlAWBZaHy9p7oWP0ciRy0Q8=";
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ curl ];
    doCheck = false;
    doInstallCheck = true;
    installCheckPhase = "$out/bin/cargo-interactive-update --help > /dev/null";
    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.fromSource ];
    };
  };

  prebuilt = stdenv.mkDerivation {
    pname = "cargo-interactive-update";
    inherit version;
    src = fetchurl {
      url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/cargo-interactive-update/${version}/cargo-interactive-update-${platformSuffix}.tar.gz";
      hash = prebuiltHash;
    };
    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
    buildInputs = [ curl ] ++ lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      tar xzf $src -C $out/bin/
      chmod +x $out/bin/cargo-interactive-update

      runHook postInstall
    '';
    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      $out/bin/cargo-interactive-update --help > /dev/null
      runHook postInstallCheck
    '';
    meta = meta // {
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };
in
if hasPrebuilt then prebuilt else sourceBuild
