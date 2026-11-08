{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  icu,
  openssl,
  zlib,
  curl,
  lttng-ust,
  stdenvNoCC,
}:

# nixpkgs source-builds the .NET SDK, which takes hours on every rebuild.
# This installs Microsoft's official prebuilt binaries instead; the version
# tracks the 8.0 LTS band via the updater (scripts/update).

let
  version = "8.0.427";

  platformSuffix =
    {
      "aarch64-darwin" = "osx-arm64";
      "x86_64-darwin" = "osx-x64";
      "aarch64-linux" = "linux-arm64";
      "x86_64-linux" = "linux-x64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "dotnet-sdk: unsupported platform ${stdenv.hostPlatform.system}");

  hashes = {
    "osx-arm64" = "sha256-B9nqS0Q7toWeUJ7GY+luo2EvLuHEknZZhSHrgDcLx3Y=";
    "osx-x64" = "sha256-BizDMqZsUQ7uv7Wdh2ewhRvj46H7Qvx12ppJLQZqPS8=";
    "linux-arm64" = "sha256-4zn2PkDZbgzaOCYzzlPSCgzn19nBd9IBnBad/1F4i2s=";
    "linux-x64" = "sha256-nypSq4J/FTC5crQffF0hHCGhbqizIXsoRhkfdG9iYUk=";
  };

  linuxLibs = lib.makeLibraryPath [
    icu
    openssl
    zlib
    curl
  ];
in
stdenvNoCC.mkDerivation {
  pname = "dotnet-sdk";
  inherit version;

  src = fetchurl {
    url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/${version}/dotnet-sdk-${version}-${platformSuffix}.tar.gz";
    hash = hashes.${platformSuffix} or (throw "dotnet-sdk: no hash for ${platformSuffix}");
  };

  # The tarball unpacks straight into the SDK layout (dotnet, sdk/, packs/…).
  sourceRoot = ".";

  dontBuild = true;
  # The darwin binaries are signed by Microsoft; stripping invalidates the
  # signature.
  dontStrip = stdenv.hostPlatform.isDarwin;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    icu
    openssl
    zlib
    curl
    # dotnet's EventPipe tracing provider (libcoreclrtraceptprovider.so)
    # links liblttng-ust directly.
    lttng-ust
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/dotnet
    cp -r . $out/lib/dotnet/

    mkdir -p $out/bin
    makeWrapper $out/lib/dotnet/dotnet $out/bin/dotnet \
      --set DOTNET_ROOT $out/lib/dotnet \
      --set DOTNET_CLI_TELEMETRY_OPTOUT 1 \
      ${lib.optionalString stdenv.hostPlatform.isLinux ''--prefix LD_LIBRARY_PATH : "${linuxLibs}"''}

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/dotnet --version | grep -q "${version}"
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Prebuilt .NET SDK (Microsoft official binaries)";
    longDescription = ''
      Microsoft's official .NET SDK binaries, installed unpacked so rebuilds
      take seconds instead of the hours a nixpkgs source build needs.
    '';
    homepage = "https://dotnet.microsoft.com/";
    license = licenses.mit;
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = [ ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "dotnet";
    tags = [
      "cli"
      "sdk"
      "dotnet"
    ];
  };
}
