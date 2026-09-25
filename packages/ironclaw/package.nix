{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
}:

let
  version = "1.4.1-rc.2";

  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "aarch64-linux" = "aarch64-unknown-linux-musl";
      "x86_64-linux" = "x86_64-unknown-linux-musl";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  hashes = {
    "aarch64-apple-darwin" = "sha256-Uv0QXh9OuHTh0XWjON2Qu0xyJCpu/iM9JylM0VQgpT8=";
    "x86_64-apple-darwin" = "sha256-0ErqTP/rCDjH3tVyyaJ0ruRclESkWf26cd0fB+3A/rg=";
    "aarch64-unknown-linux-musl" = "sha256-/WGHItsIgbwfdjY+ropeBXJiRig8lXqSrFRhlvX112g=";
    "x86_64-unknown-linux-musl" = "sha256-/AHFegT0EV+L6cUUBnMyM1m7XFRzivQn4d6XtP4ocmE=";
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
