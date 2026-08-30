{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  cargo,
  rustc,
  rustup,
  lib,
  zlib,
  openssl,
  udev,
  pname ? "agave",
  version,
  hashes,
  # Modern agave releases (>= 4.0) no longer ship the platform-tools SDK in
  # the release tarball. cargo-build-sbf >= 4.0 manages it itself, downloading
  # it on first use into ~/.cache/solana/<version>/platform-tools, and ignores
  # SBF_SDK_PATH entirely. When set, the SDK is bundled in this package
  # instead, so builds work offline and on NixOS (the prebuilt Linux binaries
  # are auto-patched at build time). Use the version reported by
  # `cargo-build-sbf --version`, e.g. "v1.54".
  platformToolsVersion ? null,
  platformToolsHashes ? { },
}:

let
  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  platformToolsName =
    {
      "aarch64-apple-darwin" = "osx-aarch64";
      "x86_64-apple-darwin" = "osx-x86_64";
      "x86_64-unknown-linux-gnu" = "linux-x86_64";
    }
    .${platformSuffix} or (throw "Unsupported platform for platform-tools: ${platformSuffix}");

  platformToolsSrc =
    if platformToolsVersion != null then
      fetchurl {
        url = "https://github.com/anza-xyz/platform-tools/releases/download/${platformToolsVersion}/platform-tools-${platformToolsName}.tar.bz2";
        sha256 = platformToolsHashes.${platformSuffix} or lib.fakeSha256;
      }
    else
      null;

  # Unpack the platform-tools SDK next to the binaries. cargo-build-sbf will
  # find it via a symlink in ~/.cache/solana/<version>/platform-tools (see the
  # wrapper below); it accepts a symlink as a valid installation.
  #
  # lldb is pruned: it is not used by cargo-build-sbf, and the upstream
  # binaries link a python (3.10 on Linux, a hardcoded homebrew path on
  # macOS) that is not available in nixpkgs, so it cannot run anyway.
  platformToolsInstallPhase =
    if platformToolsSrc != null then
      ''
        mkdir -p $out/lib/platform-tools
        tar -xjf ${platformToolsSrc} -C $out/lib/platform-tools --strip-components=1
        rm -rf \
          $out/lib/platform-tools/llvm/bin/lldb* \
          $out/lib/platform-tools/llvm/bin/solana-lldb \
          $out/lib/platform-tools/llvm/lib/liblldb* \
          $out/lib/platform-tools/llvm/lib/python*
        find $out/lib/platform-tools -type f -path '*/bin/*' -exec chmod +x {} \; 2>/dev/null || true
        # The upstream tarball ships a few dangling symlinks in the lldb
        # python bindings; drop them so the nix noBrokenSymlinks check passes.
        find $out/lib/platform-tools -type l ! -exec test -e {} \; -delete
      ''
    else
      "";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/anza-xyz/agave/releases/download/v${version}/solana-release-${platformSuffix}.tar.bz2";
    sha256 = hashes.${platformSuffix} or lib.fakeSha256;
  };

  dontBuild = true;
  dontStrip = stdenv.isDarwin;

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc.lib
    zlib
    openssl
    udev
  ];

  sourceRoot = "solana-release";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    find bin -maxdepth 1 -type f -exec cp {} $out/bin/ \;
    chmod +x $out/bin/*

    # Keep any SDK/deps directories shipped in the release tarball. Releases
    # < 4.0 ship the legacy SDK as bin/platform-tools-sdk (3.x) or bin/sdk
    # (2.x); modern releases ship neither and rely on the bundled
    # platform-tools SDK instead.
    for dir in platform-tools-sdk sdk deps; do
      if [ -d "bin/$dir" ]; then
        cp -r "bin/$dir" $out/bin/
      fi
    done

    find $out/bin/platform-tools-sdk $out/bin/sdk -type f -name '*.sh' -exec chmod +x {} \; 2>/dev/null || true

    ${platformToolsInstallPhase}

    for bin in cargo-build-sbf cargo-test-sbf; do
      if [ -f "$out/bin/$bin" ]; then
        wrapped="$out/bin/.$bin-wrapped"
        mv "$out/bin/$bin" "$wrapped"
        cat > "$out/bin/$bin" <<'EOF'
    #!${stdenv.shell}

    # cargo-build-sbf links the selected platform-tools Rust toolchain with
    # rustup, then invokes it through `cargo +<toolchain>`. Preserve the
    # consumer's host Cargo and Rust compiler for metadata before putting the
    # rustup proxies first on PATH for that explicit toolchain invocation.
    if [ "__SUBCOMMAND__" = "build-sbf" ]; then
      if [ -z "''${CARGO:-}" ]; then
        host_cargo="$(command -v cargo || true)"
        if [ -n "$host_cargo" ]; then
          export CARGO="$host_cargo"
        fi
      fi
      if [ -z "''${RUSTC:-}" ]; then
        host_rustc="$(command -v rustc || true)"
        if [ -n "$host_rustc" ]; then
          export RUSTC="$host_rustc"
        fi
      fi
      export PATH="${rustup}/bin:$PATH"
    else
      # cargo-test-sbf resolves cargo-build-sbf by name. Keep the package's
      # wrapper available without shadowing the consumer's host Cargo.
      export PATH="__OUT__/bin:$PATH"
    fi

    # Legacy SDK (agave < 4.0): the release tarball ships the SDK next to the
    # binaries (bin/platform-tools-sdk or bin/sdk) and cargo-build-sbf reads
    # its location from SBF_SDK_PATH. The nix store is read-only and the SDK
    # needs to be writable (it creates symlinks under sbf/dependencies), so
    # copy it to a per-user cache first.
    cache_root="''${XDG_CACHE_HOME:-''${HOME}/.cache}/agave/__PNAME__-__VERSION__"
    if [ -z "''${SBF_SDK_PATH:-}" ]; then
      for rel_sdk in platform-tools-sdk sdk; do
        if [ -d "__OUT__/bin/$rel_sdk" ]; then
          if [ ! -e "''${cache_root}/$rel_sdk/sbf/env.sh" ]; then
            mkdir -p "''${cache_root}"
            rm -rf "''${cache_root}/$rel_sdk"
            cp -R "__OUT__/bin/$rel_sdk" "''${cache_root}/$rel_sdk"
            chmod -R u+w "''${cache_root}/$rel_sdk"
          fi
          export SBF_SDK_PATH="''${cache_root}/$rel_sdk/sbf"
          break
        fi
      done
    fi

    # Modern SDK (agave >= 4.0): cargo-build-sbf ignores SBF_SDK_PATH and
    # manages platform-tools itself at $HOME/.cache/solana/<version>/
    # platform-tools (a symlink there counts as an installation). When this
    # package bundles platform-tools, link it into that location so no
    # download is required. The version is read from the tool itself so this
    # keeps working across cargo-build-sbf releases.
    if [ -d "__OUT__/lib/platform-tools" ]; then
      pt_version="$(__WRAPPED__ --version 2>/dev/null | sed -n 's/^platform-tools //p')"
      if [ -n "$pt_version" ]; then
        pt_root="''${HOME}/.cache/solana"
        pt_dir="$pt_root/$pt_version/platform-tools"
        if [ ! -e "$pt_dir" ]; then
          mkdir -p "$(dirname "$pt_dir")"
          ln -s "__OUT__/lib/platform-tools" "$pt_dir" 2>/dev/null || true
        fi
      fi
    fi

    pre_args=()
    cargo_args=()
    saw_separator=0
    for arg in "''$@"; do
      if [ $saw_separator -eq 0 ] && [ "''${arg}" = "__SUBCOMMAND__" ]; then
        continue
      fi

      if [ $saw_separator -eq 0 ] && [ "''${arg}" = "--" ]; then
        saw_separator=1
        continue
      fi

      if [ $saw_separator -eq 1 ]; then
        if [ "''${arg}" = "--release" ]; then
          continue
        fi
        cargo_args+=("''${arg}")
      else
        pre_args+=("''${arg}")
      fi
    done

    if [ ''${#cargo_args[@]} -gt 0 ]; then
      exec -a "''$0" "__WRAPPED__" "''${pre_args[@]}" -- "''${cargo_args[@]}"
    else
      exec -a "''$0" "__WRAPPED__" "''${pre_args[@]}"
    fi
    EOF
        substituteInPlace "$out/bin/$bin" \
          --replace-fail __OUT__ "$out" \
          --replace-fail __PNAME__ "$pname" \
          --replace-fail __SUBCOMMAND__ "''${bin#cargo-}" \
          --replace-fail __VERSION__ "$version" \
          --replace-fail __WRAPPED__ "$wrapped"
        chmod +x "$out/bin/$bin"
      fi
    done

    runHook postInstall
  '';

  nativeInstallCheckInputs = lib.optionals (platformToolsVersion != null) [
    cargo
    rustc
  ];
  doInstallCheck = platformToolsVersion != null;
  installCheckPhase = ''
    runHook preInstallCheck

    check_root="$(mktemp -d)"
    cp -R ${./test-program} "$check_root/program"
    chmod -R u+w "$check_root/program"
    mkdir -p \
      "$check_root/cache" \
      "$check_root/cargo-home" \
      "$check_root/deploy" \
      "$check_root/home" \
      "$check_root/host-bin" \
      "$check_root/rustup"

    real_cargo="$(command -v cargo)"
    real_rustc="$(command -v rustc)"
    host_cargo_log="$check_root/host-cargo.log"
    cat > "$check_root/host-bin/cargo" <<EOF
    #!${stdenv.shell}
    printf '%s\n' "\$*" >> "$host_cargo_log"
    exec "$real_cargo" "\$@"
    EOF
    chmod +x "$check_root/host-bin/cargo"

    export CARGO_HOME="$check_root/cargo-home"
    export HOME="$check_root/home"
    export HOST_CARGO_LOG="$host_cargo_log"
    export PATH="$check_root/host-bin:$(dirname "$real_rustc"):$PATH"
    export RUSTUP_HOME="$check_root/rustup"
    export XDG_CACHE_HOME="$check_root/cache"

    "$out/bin/cargo-build-sbf" \
      --manifest-path "$check_root/program/Cargo.toml" \
      --sbf-out-dir "$check_root/deploy" \
      --offline \
      --quiet
    test -f "$check_root/deploy/agave_install_check.so"
    test "$(find "$RUSTUP_HOME/toolchains" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ')" = 1
    test -z "$(find "$RUSTUP_HOME/toolchains" -mindepth 1 -maxdepth 1 ! -name '*sbpf-solana*' -print -quit)"

    "$out/bin/cargo-test-sbf" \
      --manifest-path "$check_root/program/Cargo.toml" \
      --sbf-out-dir "$check_root/deploy" \
      --offline \
      --no-run
    grep -q '^metadata ' "$host_cargo_log"
    grep -q '^test ' "$host_cargo_log"

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Solana validator client and CLI toolchain by Anza";
    homepage = "https://github.com/anza-xyz/agave";
    license = licenses.asl20;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "solana";
    tags = [
      "cli"
      "dev-tool"
      "solana"
    ];
  };
}
