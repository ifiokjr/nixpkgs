{
  lib,
  buildDartApplication,
  fetchFromGitHub,
  yq-go,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildDartApplication rec {
  pname = "serverpod_cli-3";
  version = "3.4.13";

  src = fetchFromGitHub {
    owner = "serverpod";
    repo = "serverpod";
    tag = version;
    hash = "sha256-IDIeYvjv4JqhzT39dQiVuNhwQ0STg/EwkwPRFqh5hCw=";
  };

  sourceRoot = "${src.name}/tools/serverpod_cli";

  dartEntryPoints = {
    "bin/serverpod" = "bin/serverpod_cli.dart";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

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

  meta = {
    mainProgram = "serverpod";
    homepage = "https://serverpod.dev";
    description = "Command line tools for Serverpod";
    longDescription = ''
      Serverpod is a next-generation app and web server built for the Flutter
      community. The CLI creates projects, generates protocol code, and manages
      Serverpod development workflows.
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
