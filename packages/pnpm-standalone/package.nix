{
  stdenv,
  fetchurl,
  makeWrapper,
  lib,
}:

let
  version = "10.33.0";

  platform = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x64";

  hashes = {
    "macos-arm64" = "sha256-7YofFA9N5FewHr4L464o6afiiGMxXc1T0i/x5aMtY64=";
    "macos-x64" = "sha256-wx4pVUsOP04D9GFxlclJWV5NyjYIWSIAPeSJbDykBX0=";
    "linux-arm64" = "sha256-BnVa0oF1SLhDF9hX1cgAPcbp4oQWo+p0ZyVsSatADUg=";
    "linux-x64" = "sha256-jU6PfXeOisSCAi4ldwEXBqhyVC9vbyM+eVpNn5eOqLU=";
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
          install -m 555 $src $out/libexec/pnpm

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

    install -m 755 ${./pnpm-activate-env.sh} $out/bin/pnpm-activate-env
    patchShebangs $out/bin/pnpm-activate-env

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

        echo "Checking pnpm-activate-env helper..."
        TEST_ROOT=$(mktemp -d)
        TEST_PNPM_HOME="$TEST_ROOT/pnpm-home"
        TEST_LOG="$TEST_ROOT/pnpm.log"
        : > "$TEST_LOG"

        FAKE_PNPM="$TEST_ROOT/fake-pnpm"
        printf '#!%s\n' "$(command -v bash)" > "$FAKE_PNPM"
    cat >> "$FAKE_PNPM" <<'EOF'
    set -eu

    effective_pnpm_home="''${PNPM_HOME:-''${TEST_PNPM_HOME:?}}"

    case "''${1-} ''${2-} ''${3-}" in
      "bin -g ")
        printf '%s\n' "$effective_pnpm_home"
        ;;
      "env add --global")
        version="''${4:?missing version}"
        printf 'env add %s\n' "$version" >> "''${TEST_LOG:?}"
        mkdir -p "$effective_pnpm_home/nodejs/$version/bin"
        : > "$effective_pnpm_home/nodejs/$version/bin/node"
        chmod +x "$effective_pnpm_home/nodejs/$version/bin/node"
        ;;
      *)
        printf 'unexpected fake pnpm args: %s\n' "$*" >&2
        exit 1
        ;;
    esac
    EOF
        chmod +x "$FAKE_PNPM"

        mkdir -p "$TEST_ROOT/unset-home/ws/packages/app"
        cat > "$TEST_ROOT/unset-home/ws/pnpm-workspace.yaml" <<'EOF'
    useNodeVersion: "20.11.1"
    EOF

        (
          cd "$TEST_ROOT/unset-home/ws/packages/app"
          export PNPM_ACTIVATE_PNPM_BIN="$FAKE_PNPM"
          export TEST_PNPM_HOME TEST_LOG
          unset HOME PNPM_HOME
          EXPORTS="$($out/bin/pnpm-activate-env)"
          test -n "$EXPORTS"
          eval "$EXPORTS"
          test "$PNPM_HOME" = "$TEST_PNPM_HOME"
        )

        mkdir -p "$TEST_ROOT/no-workspace"
        (
          cd "$TEST_ROOT/no-workspace"
          test -z "$($out/bin/pnpm-activate-env)"
        )

        mkdir -p "$TEST_ROOT/typo-workspace"
        cat > "$TEST_ROOT/typo-workspace/pnpm-workspace-yaml" <<'EOF'
    useNodeVersion: "20.11.1"
    EOF

        (
          cd "$TEST_ROOT/typo-workspace"
          export PNPM_ACTIVATE_PNPM_BIN="$FAKE_PNPM"
          export TEST_PNPM_HOME TEST_LOG
          export PNPM_HOME="$TEST_PNPM_HOME"
          before_lines=$(wc -l < "$TEST_LOG" | tr -d '[:space:]')
          test -z "$($out/bin/pnpm-activate-env)"
          after_lines=$(wc -l < "$TEST_LOG" | tr -d '[:space:]')
          test "$before_lines" -eq "$after_lines"
        )

        mkdir -p "$TEST_ROOT/ws/packages/app"
        cat > "$TEST_ROOT/ws/pnpm-workspace.yaml" <<'EOF'
    packages:
      - "packages/*"
    useNodeVersion: "20.11.1"
    EOF

        (
          cd "$TEST_ROOT/ws/packages/app"
          export PNPM_ACTIVATE_PNPM_BIN="$FAKE_PNPM"
          export TEST_PNPM_HOME TEST_LOG
          export PNPM_HOME="$TEST_PNPM_HOME"
          EXPORTS="$($out/bin/pnpm-activate-env)"
          test -n "$EXPORTS"
          eval "$EXPORTS"
          case ":$PATH:" in
            *":$TEST_PNPM_HOME/nodejs/20.11.1/bin:"*) ;;
            *)
              echo "pnpm-activate-env did not add Node bin path to PATH" >&2
              exit 1
              ;;
          esac
        )

        (
          cd "$TEST_ROOT/ws/packages/app"
          export PNPM_ACTIVATE_PNPM_BIN="$FAKE_PNPM"
          export TEST_PNPM_HOME TEST_LOG
          export PNPM_HOME="$TEST_PNPM_HOME"
          . "$out/bin/pnpm-activate-env"
          case ":$PATH:" in
            *":$TEST_PNPM_HOME/nodejs/20.11.1/bin:"*) ;;
            *)
              echo "sourcing pnpm-activate-env did not add Node bin path to PATH" >&2
              exit 1
              ;;
          esac
        )

        grep -q '^env add 20.11.1$' "$TEST_LOG"

        cat > "$TEST_ROOT/ws/pnpm-workspace.yaml" <<'EOF'
    useNodeVersion: lts
    EOF

        (
          cd "$TEST_ROOT/ws/packages/app"
          export PNPM_ACTIVATE_PNPM_BIN="$FAKE_PNPM"
          export TEST_PNPM_HOME TEST_LOG
          export PNPM_HOME="$TEST_PNPM_HOME"
          before_lines=$(wc -l < "$TEST_LOG" | tr -d '[:space:]')
          test -z "$($out/bin/pnpm-activate-env)"
          after_lines=$(wc -l < "$TEST_LOG" | tr -d '[:space:]')
          test "$before_lines" -eq "$after_lines"
        )

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
