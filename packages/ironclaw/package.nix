{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
}:

let
  version = "1.2.0-rc.3";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-7Bp0H2zgScbrst7lmqC2582fV8F1AjTFr2bhSUr9JGc=";
    "x86_64-apple-darwin" = "sha256-1PBrMmDCh4Fg9k0mwqRgWSdqvrHoiwKn5n/6zTnHP7A=";
    "aarch64-unknown-linux-musl" = "sha256-C5UtUQneMNCFStyQTWbNs5BgO84Oxkd1tk1SPABMVg4=";
    "x86_64-unknown-linux-musl" = "sha256-9jw7IoYc73T0lfx3aSVEvJw5uCLEF619AID0VmrW8lQ=";
  };
in
stdenv.mkDerivation {
  pname = "ironclaw";
  inherit version;

  src = fetchurl {
    url = "https://github.com/nearai/ironclaw/releases/download/ironclaw-v${version}/ironclaw-${platformSuffix}.tar.gz";
    hash = hashes.${platformSuffix} or lib.fakeHash;
  };

  dontBuild = true;
  dontStrip = true;
  dontFixup = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ironclaw $out/bin/
    chmod +x $out/bin/ironclaw

    # Install sandbox daemon alongside ironclaw (used for isolated tool execution)
    if [ -f sandbox_daemon ]; then
      cp sandbox_daemon $out/bin/
      chmod +x $out/bin/sandbox_daemon
    fi

    # Install shell completions
    installShellCompletion --cmd ironclaw \
      --bash <($out/bin/ironclaw completion --shell bash) \
      --fish <($out/bin/ironclaw completion --shell fish) \
      --zsh <($out/bin/ironclaw completion --shell zsh)

    runHook postInstall
  '';

  meta = {
    description = "Agent OS focused on privacy, security, and extensibility (NEAR AI)";
    homepage = "https://github.com/nearai/ironclaw";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "ironclaw";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "agent"
      "ai"
    ];
  };
}
