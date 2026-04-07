{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  lib,
  zlib,
  openssl,
  udev,
  pname ? "agave",
  version,
  hashes,
}:

let
  platformSuffix =
    {
      "aarch64-darwin" = "aarch64-apple-darwin";
      "x86_64-darwin" = "x86_64-apple-darwin";
      "x86_64-linux" = "x86_64-unknown-linux-gnu";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");
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

        for dir in platform-tools-sdk deps; do
          if [ -d "bin/$dir" ]; then
            cp -r "bin/$dir" $out/bin/
          fi
        done

        find $out/bin/platform-tools-sdk -type f -name '*.sh' -exec chmod +x {} \; 2>/dev/null || true

        for bin in cargo-build-sbf cargo-test-sbf; do
          if [ -f "$out/bin/$bin" ]; then
            wrapped="$out/bin/.$bin-wrapped"
            mv "$out/bin/$bin" "$wrapped"
            cat > "$out/bin/$bin" <<'EOF'
    #!${stdenv.shell}
    if [ -z "''${SBF_SDK_PATH:-}" ]; then
      cache_root="''${XDG_CACHE_HOME:-''${HOME}/.cache}/agave/__PNAME__-__VERSION__"
      sdk_root="''${cache_root}/platform-tools-sdk"
      if [ ! -e "''${sdk_root}/sbf/env.sh" ]; then
        mkdir -p "''${cache_root}"
        rm -rf "''${sdk_root}"
        cp -R "__SDK_TEMPLATE__" "''${sdk_root}"
        chmod -R u+w "''${sdk_root}"
        if [ -d "__DEPS_TEMPLATE__" ]; then
          rm -rf "''${cache_root}/deps"
          cp -R "__DEPS_TEMPLATE__" "''${cache_root}/deps"
          chmod -R u+w "''${cache_root}/deps"
        fi
      fi
      export SBF_SDK_PATH="''${sdk_root}/sbf"
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
              --replace-fail __DEPS_TEMPLATE__ "$out/bin/deps" \
              --replace-fail __PNAME__ "$pname" \
              --replace-fail __SDK_TEMPLATE__ "$out/bin/platform-tools-sdk" \
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
