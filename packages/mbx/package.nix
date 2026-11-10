{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
}:

let
  version = "1.30.0";
  tag = "v${version}";
  system = stdenv.hostPlatform.system;

  # Upstream publishes no x86_64-darwin build and statically links both Linux
  # binaries against musl, so the asset name is not the Rust target triple.
  asset =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
    }
    .${system} or (throw "mbx: unsupported system ${system}");

  hashes = {
    "aarch64-darwin" = "sha256-1blXIWyLYcLfkcnnqvX+vUXsdCdKYNNxTr4xbtwURUM=";
    "x86_64-linux" = "sha256-tSOpMk1Q/UNONV/Hpa9fcVXWKFTdalp0Fz1SZV8WjUU=";
    "aarch64-linux" = "sha256-kAhEuYD549r3eNOKGQRigcw14HEIqcghvv72EwhG3x8=";
  };
in
stdenv.mkDerivation {
  pname = "mbx";
  inherit version;

  src = fetchurl {
    url = "https://github.com/jdx/mr-boxington/releases/download/${tag}/mbx-${asset}.tar.gz";
    hash = hashes.${system} or lib.fakeHash;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  # The Darwin release binary is ad-hoc signed; stripping it invalidates the
  # signature on Apple Silicon.
  dontStrip = stdenv.hostPlatform.isDarwin;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm755 mbx $out/bin/mbx

    # Cargo shim consumed by `mbx` wrappers. It stays out of bin/ so installing
    # the package does not shadow the real cargo; projects put
    # $out/libexec/mbx on PATH when they want cargo calls wrapped.
    makeWrapper "$out/bin/mbx" "$out/libexec/mbx/cargo" \
      --set MBX_CARGO_SHIM_MODE 1 \
      --set MBX_CARGO_SHIM_PATH "$out/libexec/mbx/cargo"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/mbx --version
    runHook postInstallCheck
  '';

  meta = {
    description = "Shared build cache for Rust projects that reuses Cargo builds across worktrees";
    homepage = "https://github.com/jdx/mr-boxington";
    license = lib.licenses.mit;
    mainProgram = "mbx";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "dev-tool"
    ];
  };
}
