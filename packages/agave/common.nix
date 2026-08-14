{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  lib,
  zlib,
  openssl,
  udev,
  zstd,
  # Libraries required to auto-patch the bundled platform-tools SDK binaries
  # (llvm/lldb) on Linux.
  ncurses,
  libedit,
  libxml2,
  libffi,
  python3,
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
  platformToolsInstallPhase =
    if platformToolsSrc != null then
      ''
        mkdir -p $out/lib/platform-tools
        tar -xjf ${platformToolsSrc} -C $out/lib/platform-tools --strip-components=1
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
    zstd
    ncurses
    libedit
    libxml2
    libffi
    python3
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
