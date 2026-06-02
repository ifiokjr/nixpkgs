{
  lib,
  buildDartApplication,
  fetchurl,
  flutter,
  runCommand,
}:

buildDartApplication.override { dart = flutter; } rec {
  pname = "flutter_native_splash";
  version = "2.4.8";

  src = fetchurl {
    url = "https://pub.dev/api/archives/${pname}-${version}.tar.gz";
    hash = "sha256-nbS4CwROmvF8xLEnITf8es4AVNh574IQp2rcNKr0zf8=";
  };

  sourceRoot = ".";

  dartEntryPoints = {
    "bin/flutter-native-splash-create" = "bin/create.dart";
    "bin/flutter-native-splash-remove" = "bin/remove.dart";
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

  preConfigure = ''
    substituteInPlace pubspec.yaml \
      --replace-fail 'meta: ^1.18.0' 'meta: ^1.17.0'
  '';

  meta = {
    homepage = "https://github.com/jonbhanson/flutter_native_splash";
    description = "Generate native splash screens for Flutter apps";
    mainProgram = "flutter-native-splash-create";
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
