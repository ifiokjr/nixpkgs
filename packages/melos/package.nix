{
  lib,
  buildDartApplication,
  fetchFromGitHub,
}:

buildDartApplication (finalAttrs: {
  pname = "melos";
  version = "7.8.0";

  src = fetchFromGitHub {
    owner = "invertase";
    repo = "melos";
    tag = "melos-v${finalAttrs.version}";
    hash = "sha256-PMyfENZSczws3MyYzOGd2QXFx+5p/2yyRRFGcbEtIrw=";
  };

  patches = [
    ./add-generic-main.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  preBuild = ''
    substituteInPlace packages/melos/bin/melos.dart \
      --replace-fail '@out@' "$out"
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
