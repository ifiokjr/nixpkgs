{
  lib,
  buildDartApplication,
  fetchFromGitHub,
}:

buildDartApplication (finalAttrs: {
  pname = "melos";
  version = "7.8.2";

  src = fetchFromGitHub {
    owner = "invertase";
    repo = "melos";
    tag = "melos-v${finalAttrs.version}";
    hash = "sha256-5HLd0NUaRd0zl8WtTOGX4nHXwzCOOvCQcUW8GmmBqEw=";
  };

  patches = [
    ./add-generic-main.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  preBuild = ''
    substituteInPlace packages/melos/bin/melos.dart \
      --replace-fail '@out@' "$out" \
      --replace-fail '@version@' '${finalAttrs.version}'
    substituteInPlace packages/melos/lib/src/common/utils.dart \
      --replace-fail "final melosPackageFileUri = await Isolate.resolvePackageUri(melosPackageUri);" "return \"$out\";"
    substituteInPlace packages/melos/lib/src/common/utils.dart \
      --replace-fail "return p.normalize('\''${melosPackageFileUri!.toFilePath()}/../..');" " "
    mkdir --parents $out
    cp --recursive packages/melos/templates $out/
  '';

  meta = {
    homepage = "https://github.com/invertase/melos";
    description = "Tool for managing Dart and Flutter projects with multiple packages";
    mainProgram = "melos";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    tags = [
      "cli"
      "dart"
      "flutter"
      "monorepo"
    ];
  };
})
