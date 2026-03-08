{
  stdenv,
  fetchurl,
  makeWrapper,
  lib,
}:

let
  version = "10.31.0";

  platform = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x64";

  hashes = {
    "macos-arm64" = "sha256-byp/Ufqgu+4BP8rZvi8NUD46d9hyyPlVGGYoXGS5jNI=";
    "macos-x64" = "sha256-Ho5A4MEnJIMAl1/8UN6dfUn63ni1UkDKsdsCqTJPZdY=";
    "linux-arm64" = "sha256-Xo9bP8j8AJY2hqhQLd9YgmgbKdz+OSZxM2tmD3gScVI=";
    "linux-x64" = "sha256-IfmcjrMClnr4IM5XWkhxfQFyAyaZFvky409f+GM0AI0=";
  };

  platformKey = "${platform}-${arch}";

  # Tiny LD_PRELOAD shim that intercepts readlink("/proc/self/exe") so the
  # vercel/pkg binary sees its own path instead of the dynamic linker's path.
  # This is needed because we invoke the unmodified binary through ld-linux
  # (to avoid patching), which makes /proc/self/exe resolve to ld-linux.
  fixExePath = stdenv.mkDerivation {
    name = "fix-proc-self-exe";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/lib
      cat > fix.c << 'CFIXED'
      #define _GNU_SOURCE
      #include <dlfcn.h>
      #include <string.h>
      #include <stdlib.h>
      #include <unistd.h>
      typedef ssize_t (*readlink_fn)(const char *, char *, size_t);
      ssize_t readlink(const char *p, char *buf, size_t bufsiz) {
        readlink_fn orig = (readlink_fn)dlsym(RTLD_NEXT, "readlink");
        if (strcmp(p, "/proc/self/exe") == 0) {
          const char *real = getenv("_REAL_EXE");
          if (real) {
            size_t len = strlen(real);
            if (len > bufsiz) len = bufsiz;
            memcpy(buf, real, len);
            return (ssize_t)len;
          }
        }
        return orig(p, buf, bufsiz);
      }
      CFIXED
      $CC -shared -fPIC -o $out/lib/fixexe.so fix.c -ldl
    '';
  };
in
stdenv.mkDerivation {
  pname = "pnpm-standalone";
  inherit version;

  src = fetchurl {
    url = "https://github.com/pnpm/pnpm/releases/download/v${version}/pnpm-${platformKey}";
    sha256 = hashes.${platformKey} or lib.fakeSha256;
  };

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    ${
      if stdenv.isLinux then
        ''
          mkdir -p $out/libexec
          install -m 444 $src $out/libexec/pnpm

          INTERP=$(cat $NIX_CC/nix-support/dynamic-linker)
          makeWrapper "$INTERP" $out/bin/pnpm \
            --add-flags "$out/libexec/pnpm" \
            --set _REAL_EXE "$out/libexec/pnpm" \
            --set LD_PRELOAD "${fixExePath}/lib/fixexe.so" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
        ''
      else
        ''
          install -m 755 $src $out/bin/pnpm
        ''
    }

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    echo "Checking pnpm version..."
    $out/bin/pnpm --version

    echo "Checking pnpm init works..."
    WORK=$(mktemp -d)
    cd "$WORK"
    $out/bin/pnpm init
    test -f package.json

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Fast, disk space efficient package manager (standalone, no Node.js dependency)";
    homepage = "https://pnpm.io/";
    license = licenses.mit;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ ];
    mainProgram = "pnpm";
    tags = [
      "cli"
      "dev-tool"
      "package-manager"
    ];
  };
}
