{
  stdenv,
  fetchurl,
  lib,
  undmg,
  makeWrapper,
  channel ? "stable",
  overrideVersion ? null,
  zedHashes ? {
    "aarch64-darwin" = "sha256-WBOPWh2h0YcQINxnHEplZx+mbqUG/C/YxE1pg+wkHeE=";
    "x86_64-darwin" = "sha256-E/4bkn2X527euAjET+p/1TrXc6NJg8o0o7NdIPA5q8s=";
    "aarch64-linux" = "sha256-cVpSUiNFIryejkqMH5tGLPe7KIHu0jt8iuZQtBwkqm8=";
    "x86_64-linux" = "sha256-ZH3IXgn82ZzRdTZaibe3DM+WRpxIROuK5uuD36gvdgA=";
  },
}:

let
  pname = if channel == "preview" then "zed-preview" else "zed";
  version = "1.20.2";
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
    ++ lib.optionals stdenv.hostPlatform.isLinux [ makeWrapper ];

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

  meta = with lib; {
    description = "High-performance, multiplayer code editor from the creators of Atom and Tree-sitter";
    homepage = "https://zed.dev";
    changelog = "https://github.com/zed-industries/zed/releases/tag/${tag}";
    license = licenses.gpl3Only;
    mainProgram = pname;
    maintainers = [ ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
