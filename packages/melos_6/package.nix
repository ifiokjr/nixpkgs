{
  lib,
  buildDartApplication,
  fetchFromGitHub,
}:

buildDartApplication (finalAttrs: {
  pname = "melos";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "invertase";
    repo = "melos";
    tag = "melos-v${finalAttrs.version}";
    hash = "sha256-bhiqnBohDalUzjbrLvCWj15E4m30gluBcdxUe7xc2Zk=";
  };

  patches = [
    ./add-generic-main.patch
  ];

  # Upstream only turned the repo into a pub workspace in 7.x. The Nix build
  # resolves `package:melos` from the repo root, so register the member the
  # same way the 7.x/8.x `workspace:` declaration does.
  postPatch = ''
    printf '\nworkspace:\n  - packages/melos\n' >> pubspec.yaml
  '';

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
