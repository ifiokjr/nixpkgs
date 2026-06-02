{
  lib,
  buildDartApplication,
  fetchurl,
  flutter,
  runCommand,
}:

buildDartApplication.override { dart = flutter; } rec {
  pname = "flutter_launcher_icons";
  version = "0.14.4";

  src = fetchurl {
    url = "https://pub.dev/api/archives/${pname}-${version}.tar.gz";
    hash = "sha256-EPE3gXQaLjlyEm+uCDk9PE4B+kzXRzMmuUtyz1lBlec=";
  };

  sourceRoot = ".";

  dartEntryPoints = {
    "bin/flutter_launcher_icons" = "bin/flutter_launcher_icons.dart";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sdkSourceBuilders = {
    "flutter" =
      name:
      runCommand "flutter-sdk-${name}" { passthru.packageRoot = "."; } ''
        for path in '${flutter}/packages/${name}' '${flutter}/bin/cache/pkg/${name}'; do
          if [ -d "$path" ]; then
            ln -s "$path" "$out"
            break
          fi
        done

        if [ ! -e "$out" ]; then
          echo 1>&2 'The Flutter SDK does not contain the requested package: ${name}!'
          exit 1
        fi
      '';
  };

  meta = {
    homepage = "https://github.com/fluttercommunity/flutter_launcher_icons";
    description = "Generate launcher icons for Flutter apps";
    mainProgram = "flutter_launcher_icons";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    tags = [
      "cli"
      "dart"
      "flutter"
      "assets"
    ];
  };
}
