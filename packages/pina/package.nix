{
  lib,
  stdenv,
  fetchurl,
}:

let
  version = "0.9.0";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-gnu";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-QidMhDIzbiMvLWTq8cZfACI7CoqcBc0IXtFPrlxfUp8=";
    "x86_64-apple-darwin" = "sha256-vgoyCLK9eOWa7YLADBvoST3HdOPhonRdaPd6jKczwnc=";
    "x86_64-unknown-linux-gnu" = "sha256-AxzAJEqWLz9AWAPlcNrAlriCkeTRHVghd+5d33IwzbU=";
    "aarch64-unknown-linux-gnu" = "sha256-KTkXvYrFn+ysDVP3WojwxNDFGpNH+Xk77DnZzu2JzqU=";
  };
in
stdenv.mkDerivation {
  pname = "pina";
  inherit version;

  src = fetchurl {
    url = "https://github.com/ifiokjr/nixpkgs/releases/download/prebuilt/pina/${version}/pina-${platformSuffix}.tar.gz";
    hash = hashes.${platformSuffix} or (throw "No prebuilt for platform: ${platformSuffix}");
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    tar xzf $src -C $out/bin/
    chmod +x $out/bin/pina

    runHook postInstall
  '';

  meta = {
    description = "CLI for Pina, a performant Solana smart contract framework";
    homepage = "https://pina.rs";
    license = lib.licenses.asl20;
    mainProgram = "pina";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "dev-tool"
      "solana"
    ];
  };
}
