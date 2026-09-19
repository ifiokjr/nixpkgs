{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  zlib,
  libglvnd,
  libx11,
  libxkbcommon,
  wayland,
}:

let
  version = "1.1.0";

  platformSuffix =
    {
      "aarch64-darwin" = "macos-arm64";
      "x86_64-linux" = "linux-x64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "rive-cli: unsupported platform ${stdenv.hostPlatform.system}");

  hashes = {
    "macos-arm64" = "sha256-Nz8phF/W56iy+CqhiSdEYuyNIZM1+xhafVuWvnVLt4k=";
    "linux-x64" = "sha256-nT8nLX0X8LWd494/v1AqYK5zNd6JE78X1zw5NhMJe4Q=";
  };
in
stdenv.mkDerivation {
  pname = "rive-cli";
  inherit version;

  src = fetchurl {
    url = "https://releases.rive.app/cli/v${version}/rive-${platformSuffix}.tar.gz";
    hash = hashes.${platformSuffix} or (throw "rive-cli: no prebuilt for ${platformSuffix}");
  };

  dontBuild = true;
  # The macOS binary is signed with the hardened runtime plus a JIT
  # entitlement for the Luau VM; stripping would invalidate that signature.
  dontStrip = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # `rive` links EGL/GLESv2 for the watch-mode viewer window and X11/Wayland/
  # xkbcommon for its windowing backend. Headless commands (`--once`, `--test`)
  # work without a display, but the libraries still have to resolve.
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    zlib
    libglvnd
    libx11
    libxkbcommon
    wayland
    stdenv.cc.cc.lib
  ];

  sourceRoot = ".";

  # The tarball is `rive` alongside `docs/` and `samples/`, and the binary
  # reads those two from the directory holding its own *resolved* path. Keep
  # the three together under libexec and reach the binary through a symlink,
  # so `nix run` and the docs lookup both work.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/rive $out/bin
    cp -R rive docs samples $out/libexec/rive/
    chmod +x $out/libexec/rive/rive
    ln -s ../libexec/rive/rive $out/bin/rive

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/rive --version | grep -F "${version}"
    # Resolving the bundled docs and samples is what the libexec layout above
    # buys, so fail the build if either lookup regressed.
    $out/bin/rive docs --list > /dev/null
    test -f "$($out/bin/rive samples --path)/README.md"

    runHook postInstallCheck
  '';

  meta = {
    description = "Command-line tools for building Rive animation projects";
    longDescription = ''
      The Rive CLI turns a directory of plain source files — Luau scripts, WGSL
      shaders, RML markup, images, and fonts — into a `.riv` runtime file and an
      editable `.rev`. It previews projects in a watch window, runs headless
      builds and tests, and publishes builds to a Rive account.

      The bundled documentation is reachable offline through `rive docs` and
      the runnable examples through `rive samples`. Signing in is only needed
      for `--publish` and `--rev`; everything else works offline.
    '';
    homepage = "https://rive.app/docs/cli/getting-started";
    # Upstream ships a vendor binary with no published license terms.
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
    mainProgram = "rive";
    tags = [
      "cli"
      "animation"
      "graphics"
      "rive"
    ];
  };
}
