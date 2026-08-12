{
  lib,
  buildDartApplication,
  fetchFromGitHub,
}:

buildDartApplication rec {
  pname = "patrol_cli";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "leancodepl";
    repo = "patrol";
    tag = "patrol-v${version}";
    hash = "sha256-IlSae5SqA74Cl/55OOrNXebQSKLwFP8vIW+X9UlxhaA=";
  };

  sourceRoot = "${src.name}/packages/patrol_cli";

  dartEntryPoints = {
    "bin/patrol" = "bin/main.dart";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  # The `patrol-v${version}` monorepo tag is cut before the release script
  # bumps the embedded version constant, so sync it with the pubspec version
  # (the published pub.dev archive already has this change applied).
  preBuild = ''
    substituteInPlace lib/src/base/constants.dart \
      --replace-fail "const version = '4.5.0';" "const version = '${version}';"
  '';

  meta = {
    mainProgram = "patrol";
    homepage = "https://patrol.leancode.co";
    description = "Command-line tool for Patrol, a Flutter-native UI testing framework";
    longDescription = ''
      Patrol is a Flutter-native integration testing framework that goes beyond
      the standard integration_test package by supporting native interactions
      such as permissions, notifications, and deep links. The CLI builds test
      apps, drives tests on Android and iOS, and manages Patrol workflows.
    '';
    changelog = "https://raw.githubusercontent.com/leancodepl/patrol/patrol-v${version}/packages/patrol_cli/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    tags = [
      "cli"
      "dart"
      "flutter"
      "test"
    ];
  };
}
