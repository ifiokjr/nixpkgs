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
  version = "2.44.0-beta.02";

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
    aarch64-linux = fetch "linux_arm64" "sha256-fJO5xTe3Irme60ApyxRV+PSEyxM3BN7KCQ44WUTM+Dg=" "zip";
    x86_64-linux = fetch "linux_amd64" "sha256-tidkiDFROrAuRBcs2d6Fe10pY4vZQ8AHTZ6MZsyRTGs=" "zip";
    aarch64-darwin =
      fetch "apple_universal" "sha256-nRMcFPjg3sgdbYu8pjSTHuzHZw4qUQfOG9OUszVyTOA="
        "pkg";
    x86_64-darwin = aarch64-darwin;
  };

  platforms = lib.remove "x86_64-darwin" (builtins.attrNames sources);
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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
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

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/op --version
    runHook postInstallCheck
  '';

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
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "secrets"
      "password-manager"
    ];
  };
}
