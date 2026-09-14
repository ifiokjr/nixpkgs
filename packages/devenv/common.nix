# Shared builder for the devenv version tracks (devenv-2_0 … devenv-2_3),
# following the upstream nixpkgs recipe. devenv links against cachix's nix
# fork, so every release pins its own nix source (rev + hash) next to the
# devenv source hash — both are published in devenv's flake.lock.
{
  lib,
  applyPatches,
  fetchFromGitHub,
  fetchpatch,
  gitMinimal,
  makeBinaryWrapper,
  installShellFiles,
  rustPlatform,
  testers,
  cachix,
  nixVersions,
  openssl,
  dbus,
  protobuf,
  sqlite,
  pkg-config,
  glibcLocalesUtf8,
  llvmPackages,
  nixd,
  bash,
  version,
  hash,
  cargoHash,
  devenvNixVersion,
  devenvNixRev,
  devenvNixHash,
  # Patches (fetchpatch) applied to the pinned cachix/nix source. Older nix
  # forks predate fixes that current nixpkgs libraries require.
  devenvNixPatches ? [ ],
  postPatch ? "",
  extraNativeBuildInputs ? [ ],
  extraBuildInputs ? [ ],
  extraCheckFlags ? [ ],
}:

let
  devenvNixSrc =
    if devenvNixPatches == [ ] then
      fetchFromGitHub {
        name = "devenv-nix-${devenvNixVersion}-source";
        owner = "cachix";
        repo = "nix";
        rev = devenvNixRev;
        hash = devenvNixHash;
      }
    else
      applyPatches {
        name = "devenv-nix-${devenvNixVersion}-source";
        src = fetchFromGitHub {
          owner = "cachix";
          repo = "nix";
          rev = devenvNixRev;
          hash = devenvNixHash;
        };
        patches = devenvNixPatches;
      };

  nix_components = (nixVersions.nixComponents_git.overrideSource devenvNixSrc).overrideScope (
    finalScope: prevScope: {
      version = devenvNixVersion;
    }
  );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "devenv";
  inherit version;

  src = fetchFromGitHub {
    owner = "cachix";
    repo = "devenv";
    tag = "v${version}";
    inherit hash;
  };

  cargoHash = cargoHash;

  postPatch = postPatch;

  env = {
    RUSTFLAGS = "--cfg tracing_unstable";
    LIBSQLITE3_SYS_USE_PKG_CONFIG = "1";
    DEVENV_IS_RELEASE = true;
  };

  cargoBuildFlags = [
    "-p"
    "devenv"
    "-p"
    "devenv-run-tests"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
    protobuf
    rustPlatform.bindgenHook
  ]
  ++ extraNativeBuildInputs;

  buildInputs = [
    openssl
    sqlite
    dbus
    llvmPackages.clang-unwrapped
    nix_components.nix-expr-c
    nix_components.nix-store-c
    nix_components.nix-util-c
    nix_components.nix-flake-c
    nix_components.nix-cmd-c
    nix_components.nix-fetchers-c
    nix_components.nix-main-c
  ]
  ++ extraBuildInputs;

  nativeCheckInputs = [
    gitMinimal
    bash
  ];

  preCheck = ''
    # Initialize git repo for tests that use git-root-relative imports
    pushd $NIX_BUILD_TOP/source
    git init -b main
    git config user.email "test@example.com"
    git config user.name "Test User"
    git add -A
    popd
  '';

  useNextest = true;
  cargoTestFlags = [
    "-p"
    "devenv"
  ];

  checkFlags = extraCheckFlags;

  postInstall =
    let
      setDefaultLocaleArchive = lib.optionalString (glibcLocalesUtf8 != null) ''
        --set-default LOCALE_ARCHIVE ${glibcLocalesUtf8}/lib/locale/locale-archive
      '';
    in
    ''
      wrapProgram $out/bin/devenv \
        --prefix PATH ":" "$out/bin:${lib.getBin cachix}/bin:${lib.getBin nixd}/bin" \
        ${setDefaultLocaleArchive}

      wrapProgram $out/bin/devenv-run-tests \
        --prefix PATH ":" "$out/bin:${lib.getBin cachix}/bin:${lib.getBin nixd}/bin" \
        ${setDefaultLocaleArchive}

      # Generate manpages
      cargo xtask generate-manpages --out-dir man
      installManPage man/*

      # Generate shell completions (devenv must be in PATH)
      compdir=./completions
      export PATH="$out/bin:$PATH"
      for shell in bash fish zsh; do
        cargo xtask generate-shell-completion $shell --out-dir $compdir
      done

      installShellCompletion --cmd devenv \
        --bash $compdir/devenv.bash \
        --fish $compdir/devenv.fish \
        --zsh $compdir/_devenv
    '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "export XDG_DATA_HOME=$PWD; devenv version";
    };
  };

  meta = {
    changelog = "https://github.com/cachix/devenv/releases";
    description = "Fast, Declarative, Reproducible, and Composable Developer Environments";
    homepage = "https://github.com/cachix/devenv";
    license = lib.licenses.asl20;
    mainProgram = "devenv";
  };
})
