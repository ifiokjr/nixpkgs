{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  stdenv,
  writeScript,
  sqlite,
  yq-go,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildDartApplication rec {
  pname = "serverpod_cli-4";
  version = "4.0.0-beta.3";

  src = fetchFromGitHub {
    owner = "serverpod";
    repo = "serverpod";
    tag = version;
    hash = "sha256-Evokxbxt2ws/4+O8fYdRvGl9ISTiidzabSV9DrPNapY=";
  };

  sourceRoot = "${src.name}/tools/serverpod_cli";

  dartEntryPoints = {
    "bin/serverpod" = "bin/serverpod_cli.dart";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # `serverpod_cli` 4.x transitively depends on build-hook (native-asset)
  # packages (`sqlite3`, `sqlite3_connection_pool`) via `serverpod_embedded_postgres`.
  # nixpkgs `buildDartApplication` uses `dart compile`, and `dart compile exe` /
  # `aot-snapshot` refuse to build when build hooks are present (even on nixpkgs
  # master). `kernel` output defers native-asset resolution to runtime (the CLI
  # is run via the Dart SDK wrapper), so it sidesteps that hard refusal.
  dartOutputType = "kernel";

  nativeBuildInputs = [ yq-go ];

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  versionCheckKeepEnvironment = "HOME";

  preBuild = ''
    substituteInPlace lib/src/generated/version.dart \
      --replace-fail "const productionMode = false;" "const productionMode = true;"

    yq -i 'del(.dependency_overrides)' pubspec.yaml
  '';

  # Backport of nixpkgs 3b1d369 (2026-07-28). The fork's nixpkgs pin (3e41b24,
  # 2026-06-16) predates that fix, and `serverpod_cli` 4.x pulls `sqlite3`
  # 3.5.x via `serverpod_embedded_postgres`. sqlite3 3.5.x moved the hook file
  # to `lib/src/hook/compile/description.dart` and changed the default binary
  # resolution to a `fromGitHub` wrapper, so the upstream builder's single
  # `substituteInPlace lib/src/hook/description.dart` fails. This override
  # mirrors the fixed upstream builder; drop it once the fork bumps nixpkgs
  # past 3b1d369027816004711eaec431c67d65f07d1f08.
  customSourceBuilders.sqlite3 =
    { version, src, ... }:
    stdenv.mkDerivation {
      pname = "sqlite3";
      inherit version src;
      inherit (src) passthru;

      setupHook = writeScript "sqlite3-setup-hook" ''
        sqliteFixupHook() {
          runtimeDependencies+=('${lib.getLib sqlite}')
        }

        preFixupHooks+=(sqliteFixupHook)
      '';

      postPatch =
        if lib.versionAtLeast version "3.5.0" then
          ''
            substituteInPlace lib/src/hook/compile/description.dart \
              --replace-fail "return fromGitHub(LibraryType.sqlite3);" "return LookupSystem('sqlite3');"
          ''
        else
          lib.optionalString (lib.versionAtLeast version "3.2.0") ''
            substituteInPlace lib/src/hook/description.dart \
              --replace-fail "return PrecompiledFromGithubAssets(LibraryType.sqlite3);" "return LookupSystem('sqlite3');"
          '';

      installPhase = ''
        runHook preInstall

        cp --recursive . "$out"

        runHook postInstall
      '';
    };

  meta = {
    mainProgram = "serverpod";
    homepage = "https://serverpod.dev";
    description = "Command line tools for Serverpod (4.x beta track)";
    longDescription = ''
      Serverpod is a next-generation app and web server built for the Flutter
      community. The CLI creates projects, generates protocol code, and manages
      Serverpod development workflows.

      This is the 4.x beta track tracking pre-release `4.0.0-beta.*` versions.
      Use `serverpod_cli-3` for the stable 3.x track.
    '';
    changelog = "https://raw.githubusercontent.com/serverpod/serverpod/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    tags = [
      "cli"
      "dart"
      "flutter"
      "server"
    ];
  };
}
