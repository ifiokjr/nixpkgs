{
  stdenv,
  fetchurl,
  makeWrapper,
  lib,
  pname ? "pnpm",
  version,
  hashes,
  exeHash ? null,
  description ? "Fast, disk space efficient package manager (standalone, no Node.js dependency)",
}:

let
  npmPlatform =
    {
      "x86_64-linux" = "linux-x64";
      "aarch64-linux" = "linux-arm64";
      "x86_64-darwin" = "macos-x64";
      "aarch64-darwin" = "macos-arm64";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  platformSrc = fetchurl {
    url = "https://registry.npmjs.org/@pnpm/${npmPlatform}/-/${npmPlatform}-${version}.tgz";
    sha256 = hashes.${stdenv.hostPlatform.system} or lib.fakeSha256;
  };

  useRuntimeCommand = lib.versionAtLeast version "11";

  exeSrc =
    if exeHash != null then
      fetchurl {
        url = "https://registry.npmjs.org/@pnpm/exe/-/exe-${version}.tgz";
        sha256 = exeHash;
      }
    else
      null;

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
  inherit pname version;

  srcs = lib.optional (exeHash != null) exeSrc ++ [ platformSrc ];
  sourceRoot = "package";

  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  nativeBuildInputs = lib.optionals stdenv.isLinux [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/libexec/pnpm
    cp -r . $out/libexec/pnpm/
    chmod +x $out/libexec/pnpm/pnpm

    ${
      if stdenv.isLinux then
        ''
          INTERP=$(cat $NIX_CC/nix-support/dynamic-linker)
          makeWrapper "$INTERP" $out/bin/pnpm \
            --add-flags "$out/libexec/pnpm/pnpm" \
            --set _REAL_EXE "$out/libexec/pnpm/pnpm" \
            --set LD_PRELOAD "${fixExePath}/lib/fixexe.so" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
        ''
      else
        ''
          cat > $out/bin/pnpm <<EOF
          #!${stdenv.shell}
          exec "$out/libexec/pnpm/pnpm" "\$@"
          EOF
          chmod +x $out/bin/pnpm
        ''
    }

    # Install auxiliary executables when available (v11+)
    for aux in pn pnpx pnx; do
      if [ -f "$out/libexec/pnpm/$aux" ]; then
        install -m 755 "$out/libexec/pnpm/$aux" "$out/bin/$aux"
      fi
    done

    install -m 755 ${./pnpm-activate-env.sh} $out/bin/pnpm-activate-env
    substituteInPlace $out/bin/pnpm-activate-env \
      --replace-fail '@PNPM_ACTIVATE_USE_RUNTIME@' '${if useRuntimeCommand then "1" else "0"}'
    patchShebangs $out/bin/pnpm-activate-env

    mkdir -p $out/nix-support
    cat > $out/nix-support/setup-hook <<'EOF'
    if [ -z "''${PNPM_HOME:-}" ]; then
      if [ -n "''${XDG_DATA_HOME:-}" ]; then
        export PNPM_HOME="''${XDG_DATA_HOME}/pnpm"
      elif [ -n "''${HOME:-}" ] && [ "''${HOME}" != /homeless-shelter ]; then
        case "$(uname -s)" in
          Darwin)
            export PNPM_HOME="''${HOME}/Library/pnpm"
            ;;
          *)
            export PNPM_HOME="''${HOME}/.local/share/pnpm"
            ;;
        esac
      fi
    fi

    if [ -n "''${PNPM_HOME:-}" ]; then
      PNPM_GLOBAL_BIN="''${PNPM_HOME}${if useRuntimeCommand then "/bin" else ""}"
      case ":''${PATH:-}:" in
        *":''${PNPM_GLOBAL_BIN}:"*) ;;
        *) export PATH="''${PNPM_GLOBAL_BIN}:''${PATH:-}" ;;
      esac
      unset PNPM_GLOBAL_BIN
    fi
    EOF

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

        echo "Checking PNPM_HOME setup hook..."
        SETUP_ROOT=$(mktemp -d)
        SETUP_GLOBAL_SUFFIX="${if useRuntimeCommand then "/bin" else ""}"
        (
          export HOME="$SETUP_ROOT/home"
          export PATH="/usr/bin:/bin"
          unset PNPM_HOME
          . "$out/nix-support/setup-hook"
          case "$(uname -s)" in
            Darwin)
              test "$PNPM_HOME" = "$HOME/Library/pnpm"
              ;;
            *)
              test "$PNPM_HOME" = "$HOME/.local/share/pnpm"
              ;;
          esac
          case ":$PATH:" in
            *":$PNPM_HOME$SETUP_GLOBAL_SUFFIX:"*) ;;
            *)
              echo "setup-hook did not add PNPM global bin to PATH" >&2
              exit 1
              ;;
          esac
        )
        (
          export HOME="$SETUP_ROOT/home"
          export PNPM_HOME="$SETUP_ROOT/custom-pnpm-home"
          export PATH="/usr/bin:/bin"
          . "$out/nix-support/setup-hook"
          test "$PNPM_HOME" = "$SETUP_ROOT/custom-pnpm-home"
          case ":$PATH:" in
            *":$SETUP_ROOT/custom-pnpm-home$SETUP_GLOBAL_SUFFIX:"*) ;;
            *)
              echo "setup-hook did not preserve and add custom PNPM global bin to PATH" >&2
              exit 1
              ;;
          esac
        )
        (
          export HOME="/homeless-shelter"
          export XDG_DATA_HOME="$SETUP_ROOT/xdg-data"
          export PATH="/usr/bin:/bin"
          unset PNPM_HOME
          . "$out/nix-support/setup-hook"
          test "$PNPM_HOME" = "$XDG_DATA_HOME/pnpm"
          case ":$PATH:" in
            *":$XDG_DATA_HOME/pnpm$SETUP_GLOBAL_SUFFIX:"*) ;;
            *)
              echo "setup-hook did not use XDG_DATA_HOME global bin when HOME is /homeless-shelter" >&2
              exit 1
              ;;
          esac
        )
        (
          export HOME="/homeless-shelter"
          export PATH="/usr/bin:/bin"
          unset XDG_DATA_HOME PNPM_HOME
          . "$out/nix-support/setup-hook"
          test -z "''${PNPM_HOME:-}"
          test "$PATH" = "/usr/bin:/bin"
        )

        echo "Checking pnpm-activate-env helper..."
        TEST_ROOT=$(mktemp -d)
        TEST_PNPM_HOME="$TEST_ROOT/pnpm-home"
        TEST_LOG="$TEST_ROOT/pnpm.log"
        TEST_USE_RUNTIME="${if useRuntimeCommand then "1" else "0"}"
        TEST_GLOBAL_BIN="$TEST_PNPM_HOME${if useRuntimeCommand then "/bin" else ""}"
        TEST_NODE_BIN="$TEST_PNPM_HOME${if useRuntimeCommand then "/bin" else "/nodejs/20.11.1/bin"}"
        TEST_INSTALL_LOG="${
          if useRuntimeCommand then "runtime set node 20.11.1" else "env add 20.11.1"
        }"
        : > "$TEST_LOG"

        FAKE_PNPM="$TEST_ROOT/fake-pnpm"
        printf '#!%s\n' "$(command -v bash)" > "$FAKE_PNPM"
    cat >> "$FAKE_PNPM" <<'EOF'
        set -eu

        effective_pnpm_home="''${PNPM_HOME:-''${TEST_PNPM_HOME:?}}"

        case "''${1-} ''${2-} ''${3-}" in
          "bin -g ")
            printf '%s\n' "''${TEST_FAKE_GLOBAL_BIN:-$effective_pnpm_home}"
            ;;
          "env add --global")
            version="''${4:?missing version}"
            printf 'env add %s\n' "$version" >> "''${TEST_LOG:?}"
            mkdir -p "$effective_pnpm_home/nodejs/$version/bin"
            : > "$effective_pnpm_home/nodejs/$version/bin/node"
            chmod +x "$effective_pnpm_home/nodejs/$version/bin/node"
            ;;
          "runtime set node")
            version="''${4:?missing version}"
            global_flag="''${5:?missing global flag}"
            test "$global_flag" = "--global"
            printf 'runtime set node %s\n' "$version" >> "''${TEST_LOG:?}"
            mkdir -p "$effective_pnpm_home/bin"
            : > "$effective_pnpm_home/bin/node"
            chmod +x "$effective_pnpm_home/bin/node"
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

        mkdir -p "$TEST_ROOT/homeless-home/ws"
        cat > "$TEST_ROOT/homeless-home/ws/pnpm-workspace.yaml" <<'EOF'
        useNodeVersion: "20.11.1"
        EOF

        (
          cd "$TEST_ROOT/homeless-home/ws"
          export PNPM_ACTIVATE_PNPM_BIN="$FAKE_PNPM"
          export TEST_FAKE_GLOBAL_BIN="/homeless-shelter/.local/share/pnpm"
          export TEST_LOG
          export HOME="/homeless-shelter"
          export XDG_DATA_HOME="$TEST_ROOT/xdg-data"
          unset PNPM_HOME
          EXPORTS="$($out/bin/pnpm-activate-env)"
          test -n "$EXPORTS"
          eval "$EXPORTS"
          test "$PNPM_HOME" = "$XDG_DATA_HOME/pnpm"
        )

        (
          cd "$TEST_ROOT/homeless-home/ws"
          export PNPM_ACTIVATE_PNPM_BIN="$FAKE_PNPM"
          export TEST_FAKE_GLOBAL_BIN="/homeless-shelter/.local/share/pnpm"
          export TEST_LOG
          export HOME="/homeless-shelter"
          unset XDG_DATA_HOME PNPM_HOME
          EXPORTS="$($out/bin/pnpm-activate-env)"
          test -n "$EXPORTS"
          eval "$EXPORTS"
          test "$PNPM_HOME" = "$PWD/.pnpm-home"
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
          export PATH="$TEST_NODE_BIN:/usr/bin:$TEST_PNPM_HOME:/bin"
          EXPORTS="$($out/bin/pnpm-activate-env)"
          test -n "$EXPORTS"
          eval "$EXPORTS"
          case "$PATH" in
            "$TEST_GLOBAL_BIN:"*) ;;
            *)
              echo "pnpm-activate-env did not prioritize PNPM_HOME on PATH" >&2
              exit 1
              ;;
          esac
          case ":$PATH:" in
            *":$TEST_NODE_BIN:") ;;
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
          export PATH="$TEST_NODE_BIN:/usr/bin:$TEST_PNPM_HOME:/bin"
          . "$out/bin/pnpm-activate-env"
          case "$PATH" in
            "$TEST_GLOBAL_BIN:"*) ;;
            *)
              echo "sourcing pnpm-activate-env did not prioritize PNPM_HOME before Node bin path" >&2
              exit 1
              ;;
          esac
          case ":$PATH:" in
            *":$TEST_NODE_BIN:") ;;
            *)
              echo "sourcing pnpm-activate-env did not add Node bin path to PATH" >&2
              exit 1
              ;;
          esac
        )

        grep -q "^$TEST_INSTALL_LOG$" "$TEST_LOG"

        mkdir -p "$TEST_ROOT/runtime-package/packages/app"
        cat > "$TEST_ROOT/runtime-package/package.json" <<'EOF'
        {
          "devEngines": {
            "runtime": {
              "name": "node",
              "version": "^20.11.1",
              "onFail": "download"
            }
          }
        }
        EOF

        (
          cd "$TEST_ROOT/runtime-package/packages/app"
          export PNPM_ACTIVATE_PNPM_BIN="$FAKE_PNPM"
          export TEST_PNPM_HOME TEST_LOG
          export PNPM_HOME="$TEST_PNPM_HOME"
          before_lines=$(wc -l < "$TEST_LOG" | tr -d '[:space:]')
          EXPORTS="$($out/bin/pnpm-activate-env)"
          if [ "$TEST_USE_RUNTIME" = "1" ]; then
            test -n "$EXPORTS"
            grep -q '^runtime set node \^20.11.1$' "$TEST_LOG"
          else
            test -z "$EXPORTS"
            after_lines=$(wc -l < "$TEST_LOG" | tr -d '[:space:]')
            test "$before_lines" -eq "$after_lines"
          fi
        )

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
    inherit description;
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
