{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  autoPatchelfHook,
  installShellFiles,
  cpio,
  xar,
}:

let
  version = "2.35.0-beta.01";

  fetch =
    srcPlatform: hash: extension:
    let
      args = {
        url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_${srcPlatform}_v${version}.${extension}";
        inherit hash;
      }
      // lib.optionalAttrs (extension == "zip") { stripRoot = false; };
    in
    if extension == "zip" then fetchzip args else fetchurl args;

  sources = rec {
    aarch64-linux = fetch "linux_arm64" "sha256-HlmNAnHeFvWplcIBSWHP6REbEfBTWKtzMURUrqu3Ns0=" "zip";
    x86_64-linux = fetch "linux_amd64" "sha256-oNzlRzPPMxc3oA4UkSV/VohqzoLAo9SBxcwzqdcwW84=" "zip";
    aarch64-darwin =
      fetch "apple_universal" "sha256-5SA1qClHRXei64xFUrykecQO7Le5GlANHj25XCCjt2I="
        "pkg";
    x86_64-darwin = aarch64-darwin;
  };

  platforms = builtins.attrNames sources;
in

stdenv.mkDerivation {
  pname = "op";
  inherit version;

  src =
    if (builtins.elem stdenv.hostPlatform.system platforms) then
      sources.${stdenv.hostPlatform.system}
    else
      throw "Source for op (1password-cli beta) is not available for ${stdenv.hostPlatform.system}";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook
  ++ lib.optional stdenv.hostPlatform.isDarwin [
    xar
    cpio
  ];

  unpackPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    xar -xf $src
    zcat op.pkg/Payload | cpio -i
  '';

  installPhase = ''
    runHook preInstall
    install -D op $out/bin/op
    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    HOME=$TMPDIR
    installShellCompletion --cmd op \
      --bash <($out/bin/op completion bash) \
      --fish <($out/bin/op completion fish) \
      --zsh <($out/bin/op completion zsh)
  '';

  dontStrip = stdenv.hostPlatform.isDarwin;

  meta = {
    description = "1Password CLI (beta channel) with environment support";
    homepage = "https://developer.1password.com/docs/cli/";
    downloadPage = "https://app-updates.agilebits.com/product_history/CLI2";
    license = lib.licenses.unfree;
    mainProgram = "op";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "secrets"
      "password-manager"
    ];
  };
}
