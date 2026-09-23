{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  channel ? "stable",
  overrideVersion ? null,
  # Keyed by the upstream release asset suffix; the updater rewrites this
  # record alongside `version`.
  t3codeHashes ? {
    "darwin-arm64" = "sha256-8VuMTEcJKz06SuLCSx4buT0kphjtvIrt/ERVo2t2d0o=";
    "linux-arm64" = "sha256-feR+Znk8kbAe4/swTZ0tyacBmqqPhcVbU11tjKPhQBM=";
    "linux-x64" = "sha256-9QTpMe5EBr/nZ1QUfLDioPMA11xsUFoOF0oeefZc7qM=";
  },
}:

let
  pname = if channel == "nightly" then "t3code-nightly" else "t3code";
  version = "0.0.42";
  resolvedVersion = if overrideVersion == null then version else overrideVersion;

  # Upstream ships no Intel macOS CLI archive; the desktop app is the supported
  # path there.
  assetSuffix =
    {
      "aarch64-darwin" = "darwin-arm64";
      "aarch64-linux" = "linux-arm64";
      "x86_64-linux" = "linux-x64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  archive = "t3-${resolvedVersion}-${assetSuffix}.tar.gz";
in
stdenv.mkDerivation {
  inherit pname;
  version = resolvedVersion;

  src = fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${resolvedVersion}/${archive}";
    hash = t3codeHashes.${assetSuffix} or lib.fakeHash;
  };

  sourceRoot = "t3-${resolvedVersion}-${assetSuffix}";

  dontConfigure = true;
  dontBuild = true;
  # The macOS executables are code-signed, and the Linux `t3` carries its
  # application payload in a `.note.node.sea` PT_NOTE segment.
  dontStrip = true;
  # Around 2600 bundled files carry shebangs that are never used as entry
  # points; rewriting them all only costs build time.
  dontPatchShebangs = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  # Linux archives ship musl variants of the native addons next to the glibc
  # ones, selected at runtime by `detect-libc`; their `libc.so` never resolves
  # against a glibc target.
  autoPatchelfIgnoreMissingDeps = lib.optionals stdenv.hostPlatform.isLinux [ "libc.so" ];

  installPhase = ''
    runHook preInstall

    # `t3` resolves `client/`, `node_modules/` and `resource-monitor/` relative
    # to its own real path, so the bundle has to stay intact and `bin/t3` has to
    # be a symlink into it — the layout upstream's install script uses.
    mkdir -p $out/libexec/t3 $out/bin
    cp -R . $out/libexec/t3/

    chmod +x $out/libexec/t3/t3
    chmod +x $out/libexec/t3/resource-monitor/*/t3-resource-monitor
    # node-pty ships this helper without an executable bit and forks it at
    # runtime from a read-only store path, so set it here.
    for helper in \
      $out/libexec/t3/node_modules/node-pty/prebuilds/${assetSuffix}/spawn-helper \
      $out/libexec/t3/node_modules/node-pty/build/Release/spawn-helper; do
      if [ -f "$helper" ]; then chmod +x "$helper"; fi
    done

    ln -s $out/libexec/t3/t3 $out/bin/t3

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/t3 --version

    runHook postInstallCheck
  '';

  meta = {
    description = "Control surface for the coding agents running on your machine";
    longDescription = ''
      T3 Code runs a local server that drives the coding agents already
      installed on the machine (Claude Code, Codex, Cursor, Grok Build,
      OpenCode and Antigravity) and serves a local web app alongside a pairing
      endpoint for its mobile and desktop clients.

      This installs the self-contained upstream CLI archive, which bundles the
      server, the web client and its native addons. At least one supported
      provider has to be installed and authenticated before use.
    '';
    homepage = "https://t3.codes";
    changelog = "https://github.com/pingdotgg/t3code/releases/tag/v${resolvedVersion}";
    license = lib.licenses.mit;
    mainProgram = "t3";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    tags = [
      "cli"
      "agent"
      "ai"
    ];
  };
}
