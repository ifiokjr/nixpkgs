{
  description = "Additional Nix packages not yet available in nixpkgs";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-linux"
      ];

      # Nests each per-system result under its top-level attribute name,
      # i.e. `{ packages = ...; }` becomes `packages.<system> = ...`, the
      # same shape flake-utils.lib.eachSystem produces.
      eachSystem =
        f:
        builtins.foldl' (
          acc: system:
          builtins.mapAttrs (name: value: acc.${name} or { } // { ${system} = value; }) (f system)
        ) { } systems;

      # Single source of truth for the package set, shared by overlays.default
      # and packages.<system>. `self` is the attribute set aliases resolve
      # through: the overlay passes `final`, so a later overlay overriding a
      # package also redirects its aliases; the packages output passes the set
      # itself.
      packageSet = pkgs: self: {
        agave-2_0 = pkgs.callPackage ./packages/agave-2_0/package.nix { };
        agave-2_1 = pkgs.callPackage ./packages/agave-2_1/package.nix { };
        agave-2_2 = pkgs.callPackage ./packages/agave-2_2/package.nix { };
        agave-2_3 = pkgs.callPackage ./packages/agave-2_3/package.nix { };
        agave-3_0 = pkgs.callPackage ./packages/agave-3_0/package.nix { };
        agave-3_1 = pkgs.callPackage ./packages/agave-3_1/package.nix { };
        agave-4_0 = pkgs.callPackage ./packages/agave-4_0/package.nix { };
        agave-4_1 = pkgs.callPackage ./packages/agave-4_1/package.nix { };
        agave-4_2 = pkgs.callPackage ./packages/agave-4_2/package.nix { };
        agave-4_3 = pkgs.callPackage ./packages/agave-4_3/package.nix { };
        agave = self.agave-4_2;
        solana = self.agave;
        cargo-clean-all = pkgs.callPackage ./packages/cargo-clean-all/package.nix { };
        cargo-interactive-update = pkgs.callPackage ./packages/cargo-interactive-update/package.nix { };
        ccase = pkgs.callPackage ./packages/ccase/package.nix { };
        codex-cli = pkgs.callPackage ./packages/codex-cli/package.nix { };
        deno = pkgs.callPackage ./packages/deno/package.nix { };
        dylint = pkgs.callPackage ./packages/dylint/package.nix { };
        flutter_launcher_icons = pkgs.callPackage ./packages/flutter_launcher_icons/package.nix { };
        flutter-launcher-icons = self.flutter_launcher_icons;
        flutter_native_splash = pkgs.callPackage ./packages/flutter_native_splash/package.nix { };
        flutter-native-splash = self.flutter_native_splash;
        godot = pkgs.callPackage ./packages/godot/package.nix { };
        gpg-suite = pkgs.callPackage ./packages/gpg-suite/package.nix { };
        herdr = pkgs.callPackage ./packages/herdr/package.nix { };
        ironclaw = pkgs.callPackage ./packages/ironclaw/package.nix { };
        kani = pkgs.callPackage ./packages/kani/package.nix { };
        knope = pkgs.callPackage ./packages/knope/package.nix { };
        mdt = pkgs.callPackage ./packages/mdt/package.nix { };
        melos_6 = pkgs.callPackage ./packages/melos_6/package.nix { };
        melos_7 = pkgs.callPackage ./packages/melos_7/package.nix { };
        melos_8 = pkgs.callPackage ./packages/melos_8/package.nix { };
        melos = self.melos_8;
        melos-cli = self.melos;
        monochange = pkgs.callPackage ./packages/monochange/package.nix { };
        monosecret = pkgs.callPackage ./packages/monosecret/package.nix { };
        monostyle = pkgs.callPackage ./packages/monostyle/package.nix { };
        nordvpn = pkgs.callPackage ./packages/nordvpn/package.nix { };
        ollama = pkgs.callPackage ./packages/ollama/package.nix { };
        op = pkgs.callPackage ./packages/op/package.nix { };
        patrol_cli = pkgs.callPackage ./packages/patrol_cli/package.nix { };
        patrol = self.patrol_cli;
        patrol-cli = self.patrol_cli;
        pina = pkgs.callPackage ./packages/pina/package.nix { };
        pnpm = pkgs.callPackage ./packages/pnpm/package.nix { };
        pnpm-10 = pkgs.callPackage ./packages/pnpm-10/package.nix { };
        pnpm-11 = pkgs.callPackage ./packages/pnpm-11/package.nix { };
        pnpm-standalone = pkgs.callPackage ./packages/pnpm-standalone/package.nix {
          pnpm = self.pnpm;
        };
        racket-minimal = pkgs.callPackage ./packages/racket-minimal/package.nix { };
        rive-cli = pkgs.callPackage ./packages/rive-cli/package.nix { };
        sbpf-linker = pkgs.callPackage ./packages/sbpf-linker/package.nix { };
        solana-verify = pkgs.callPackage ./packages/solana-verify/package.nix { };
        serverpod_cli-3 = pkgs.callPackage ./packages/serverpod_cli-3/package.nix { };
        serverpod_cli-4 = pkgs.callPackage ./packages/serverpod_cli-4/package.nix { };
        serverpod = self.serverpod_cli-4;
        serverpod-cli = self.serverpod_cli-4;
        serverpod_cli = self.serverpod_cli-4;
        steam = pkgs.callPackage ./packages/steam/package.nix { };
        surfpool = pkgs.callPackage ./packages/surfpool/package.nix { };
        t3code = pkgs.callPackage ./packages/t3code/package.nix { };
        t3code-nightly = pkgs.callPackage ./packages/t3code-nightly/package.nix { };
        wait-for-them = pkgs.callPackage ./packages/wait-for-them/package.nix { };
        zed = pkgs.callPackage ./packages/zed/package.nix { };
        zed-preview = pkgs.callPackage ./packages/zed-preview/package.nix { };
        zoom = pkgs.callPackage ./packages/zoom/package.nix { };
      };
    in
    {
      overlays.default = final: _prev: packageSet final final;
    }
    // eachSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        lib = pkgs.lib;

        # Lazy self-reference: aliases inside packageSet resolve through this
        # very attribute set.
        packages = packageSet pkgs packages;

        supportedPackages = lib.filterAttrs (
          _: pkg: lib.meta.availableOn pkgs.stdenv.hostPlatform pkg
        ) packages;

        # Package names for the CI build matrices. Derived from the flake so
        # the lists can never drift from the real package set (hand-maintained
        # lists silently rotted and disabled every build job). Aliases map to
        # the same derivation and become instant cache hits in CI.
        ciPackages = builtins.attrNames supportedPackages;

        allPkg = pkgs.symlinkJoin {
          name = "all-packages";
          paths = builtins.attrValues supportedPackages;
        };
      in
      {
        inherit ciPackages;

        checks.github-workflows =
          pkgs.runCommand "github-workflows"
            {
              nativeBuildInputs = [
                pkgs.actionlint
                pkgs.zizmor
              ];
            }
            ''
              cd ${./.}
              actionlint .github/workflows/*.yml
              # Explicit file inputs: zizmor's project discovery needs a
              # .git that store copies do not have.
              zizmor --offline --min-severity=high .github/workflows/*.yml
              touch $out
            '';

        packages = packages // {
          all = allPkg;
        };
      }
    );
}
