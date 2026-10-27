{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
  patchelf,
  channel ? "stable",
  overrideVersion ? null,
  zedHashes ? {
    "aarch64-darwin" = "sha256-8z4KpohFIoT+bgU4agQIsJkg59GBJatNgzU2KLdfM9o=";
    "x86_64-darwin" = "sha256-MVn7d+FDwVV2JRAQDnZeg5n7b3RBmJjjpIEusu3RfO4=";
    "aarch64-linux" = "sha256-d2s6XjnxIY6sq+Hp+jhZt6bdomU1ItijmSqasPIYQFg=";
    "x86_64-linux" = "sha256-NfkRWs2LTDvqbtIPfJtuyPHSwt1aHMQ41VIWe17Us0I=";
  },
}:

let
  pname = if channel == "preview" then "zed-preview" else "zed";
  version = "1.25.3";
  resolvedVersion = if overrideVersion == null then version else overrideVersion;
  tag = "v${resolvedVersion}";
  arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
  asset = if stdenv.hostPlatform.isDarwin then "Zed-${arch}.dmg" else "zed-linux-${arch}.tar.gz";
  platformKey = if stdenv.hostPlatform.isDarwin then "${arch}-darwin" else "${arch}-linux";
  appName = if channel == "preview" then "Zed Preview" else "Zed";
  appDir = if channel == "preview" then "zed-preview.app" else "zed.app";
  desktopFile = if channel == "preview" then "dev.zed.Zed-Preview.desktop" else "dev.zed.Zed.desktop";
in
stdenv.mkDerivation {
  inherit pname;
  version = resolvedVersion;

  src = fetchurl {
    url = "https://github.com/zed-industries/zed/releases/download/${tag}/${asset}";
    hash = zedHashes.${platformKey} or lib.fakeHash;
  };

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isDarwin [ undmg ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      makeWrapper
      patchelf
    ];

  sourceRoot = ".";
  dontUnpack = stdenv.hostPlatform.isDarwin;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications $out/bin

    mountpoint=$TMPDIR/zed-dmg
    mkdir -p "$mountpoint"
    /usr/bin/hdiutil attach -nobrowse -readonly -mountpoint "$mountpoint" "$src"

    app=$(find "$mountpoint" -maxdepth 2 -name "*.app" -type d | head -n 1)
    cp -R "$app" $out/Applications/
    /usr/bin/hdiutil detach "$mountpoint"

    installed_app="$out/Applications/$(basename "$app")"
    if [ -x "$installed_app/Contents/MacOS/cli" ]; then
      ln -s "$installed_app/Contents/MacOS/cli" $out/bin/${pname}
    elif [ -x "$installed_app/Contents/MacOS/${appName}" ]; then
      ln -s "$installed_app/Contents/MacOS/${appName}" $out/bin/${pname}
    fi
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out
    cp -R ${appDir}/* $out/

    if [ -x $out/bin/zed ]; then
      mv $out/bin/zed $out/bin/.zed-unwrapped
      # Upstream builds against the host glibc; rewrite the ELF interpreter
      # so the binary runs under the nix-provided loader. Runtime libraries
      # come from the tarball itself via the wrapper's LD_LIBRARY_PATH.
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/.zed-unwrapped
      makeWrapper $out/bin/.zed-unwrapped $out/bin/${pname} \
        --prefix LD_LIBRARY_PATH : $out/lib
    fi

    if [ -f $out/share/applications/${desktopFile} ]; then
      substituteInPlace $out/share/applications/${desktopFile} \
        --replace-fail "Exec=zed" "Exec=${pname}" \
        --replace-fail "Name=Zed" "Name=${appName}"
    fi
  ''
  + ''
    runHook postInstall
  '';

  # The darwin CLI is a symlink into the .app bundle and mutates bundle
  # state (LaunchServices) when run, which breaks sandbox finalization —
  # so only the plain-binary Linux build is smoke-tested.
  doInstallCheck = stdenv.hostPlatform.isLinux;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/${pname} --version
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "High-performance, multiplayer code editor from the creators of Atom and Tree-sitter";
    homepage = "https://zed.dev";
    changelog = "https://github.com/zed-industries/zed/releases/tag/${tag}";
    license = licenses.gpl3Only;
    mainProgram = pname;
    maintainers = [ ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
