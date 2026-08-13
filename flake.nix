{
  description = "Additional Nix packages not yet available in nixpkgs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    {
      overlays.default = final: _prev: rec {
        agave = final.agave-4_2;
        solana = final.agave;
        agave-2_0 = final.callPackage ./packages/agave-2_0/package.nix { };
        agave-2_1 = final.callPackage ./packages/agave-2_1/package.nix { };
        agave-2_2 = final.callPackage ./packages/agave-2_2/package.nix { };
        agave-2_3 = final.callPackage ./packages/agave-2_3/package.nix { };
        agave-3_0 = final.callPackage ./packages/agave-3_0/package.nix { };
        agave-3_1 = final.callPackage ./packages/agave-3_1/package.nix { };
        agave-4_0 = final.callPackage ./packages/agave-4_0/package.nix { };
        agave-4_1 = final.callPackage ./packages/agave-4_1/package.nix { };
        agave-4_2 = final.callPackage ./packages/agave-4_2/package.nix { };
        agave-4_3 = final.callPackage ./packages/agave-4_3/package.nix { };
        cargo-clean-all = final.callPackage ./packages/cargo-clean-all/package.nix { };
        ccase = final.callPackage ./packages/ccase/package.nix { };
        dylint = final.callPackage ./packages/dylint/package.nix { };
        cargo-interactive-update = final.callPackage ./packages/cargo-interactive-update/package.nix { };
        codex-cli = final.callPackage ./packages/codex-cli/package.nix { };
        deno = final.callPackage ./packages/deno/package.nix { };
        flutter-launcher-icons = flutter_launcher_icons;
        flutter-native-splash = flutter_native_splash;
        flutter_launcher_icons = final.callPackage ./packages/flutter_launcher_icons/package.nix { };
        flutter_native_splash = final.callPackage ./packages/flutter_native_splash/package.nix { };
        godot = final.callPackage ./packages/godot/package.nix { };
        gpg-suite = final.callPackage ./packages/gpg-suite/package.nix { };
        herdr = final.callPackage ./packages/herdr/package.nix { };
        ironclaw = final.callPackage ./packages/ironclaw/package.nix { };
        kani = final.callPackage ./packages/kani/package.nix { };
        keyring = final.callPackage ./packages/keyring/package.nix { };
        knope = final.callPackage ./packages/knope/package.nix { };
        mdt = final.callPackage ./packages/mdt/package.nix { };
        melos-cli = melos;
        melos = final.callPackage ./packages/melos/package.nix { };
        monochange = final.callPackage ./packages/monochange/package.nix { };
        nordvpn = final.callPackage ./packages/nordvpn/package.nix { };
        ollama = final.callPackage ./packages/ollama/package.nix { };
        op = final.callPackage ./packages/op/package.nix { };
        patrol = patrol_cli;
        patrol-cli = patrol_cli;
        patrol_cli = final.callPackage ./packages/patrol_cli/package.nix { };
        pina = final.callPackage ./packages/pina/package.nix { };
        pnpm = final.callPackage ./packages/pnpm/package.nix { };
        pnpm-10 = final.callPackage ./packages/pnpm-10/package.nix { };
        pnpm-11 = final.callPackage ./packages/pnpm-11/package.nix { };
        monosecret = final.callPackage ./packages/monosecret/package.nix { };
        pnpm-standalone = final.callPackage ./packages/pnpm-standalone/package.nix { inherit pnpm; };
        racket-minimal = final.callPackage ./packages/racket-minimal/package.nix { };
        sbpf-linker = sbpf-linker-22;
        sbpf-linker-21 = final.callPackage ./packages/sbpf-linker/package.nix { variant = "21"; };
        sbpf-linker-22 = final.callPackage ./packages/sbpf-linker/package.nix { variant = "22"; };
        solana-verify = final.callPackage ./packages/solana-verify/package.nix { };
        serverpod = serverpod_cli-3;
        serverpod-cli = serverpod_cli-3;
        serverpod_cli = serverpod_cli-3;
        serverpod_cli-3 = final.callPackage ./packages/serverpod_cli-3/package.nix { };
        serverpod_cli-4 = final.callPackage ./packages/serverpod_cli-4/package.nix { };
        steam = final.callPackage ./packages/steam/package.nix { };
        surfpool = final.callPackage ./packages/surfpool/package.nix { };
        wait-for-them = final.callPackage ./packages/wait-for-them/package.nix { };
        zed = final.callPackage ./packages/zed/package.nix { };
        zed-preview = final.callPackage ./packages/zed-preview/package.nix { };
        zoom = final.callPackage ./packages/zoom/package.nix { };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        lib = pkgs.lib;

        packages = rec {
          agave = agave-4_2;
          solana = agave;
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
          cargo-clean-all = pkgs.callPackage ./packages/cargo-clean-all/package.nix { };
          ccase = pkgs.callPackage ./packages/ccase/package.nix { };
          dylint = pkgs.callPackage ./packages/dylint/package.nix { };
          cargo-interactive-update = pkgs.callPackage ./packages/cargo-interactive-update/package.nix { };
          codex-cli = pkgs.callPackage ./packages/codex-cli/package.nix { };
          deno = pkgs.callPackage ./packages/deno/package.nix { };
          flutter-launcher-icons = flutter_launcher_icons;
          flutter-native-splash = flutter_native_splash;
          flutter_launcher_icons = pkgs.callPackage ./packages/flutter_launcher_icons/package.nix { };
          flutter_native_splash = pkgs.callPackage ./packages/flutter_native_splash/package.nix { };
          godot = pkgs.callPackage ./packages/godot/package.nix { };
          gpg-suite = pkgs.callPackage ./packages/gpg-suite/package.nix { };
          herdr = pkgs.callPackage ./packages/herdr/package.nix { };
          ironclaw = pkgs.callPackage ./packages/ironclaw/package.nix { };
          kani = pkgs.callPackage ./packages/kani/package.nix { };
          keyring = pkgs.callPackage ./packages/keyring/package.nix { };
          knope = pkgs.callPackage ./packages/knope/package.nix { };
          mdt = pkgs.callPackage ./packages/mdt/package.nix { };
          melos-cli = melos;
          melos = pkgs.callPackage ./packages/melos/package.nix { };
          monochange = pkgs.callPackage ./packages/monochange/package.nix { };
          nordvpn = pkgs.callPackage ./packages/nordvpn/package.nix { };
          ollama = pkgs.callPackage ./packages/ollama/package.nix { };
          op = pkgs.callPackage ./packages/op/package.nix { };
          patrol = patrol_cli;
          patrol-cli = patrol_cli;
          patrol_cli = pkgs.callPackage ./packages/patrol_cli/package.nix { };
          pina = pkgs.callPackage ./packages/pina/package.nix { };
          pnpm = pkgs.callPackage ./packages/pnpm/package.nix { };
          pnpm-10 = pkgs.callPackage ./packages/pnpm-10/package.nix { };
          pnpm-11 = pkgs.callPackage ./packages/pnpm-11/package.nix { };
          monosecret = pkgs.callPackage ./packages/monosecret/package.nix { };
          pnpm-standalone = pkgs.callPackage ./packages/pnpm-standalone/package.nix { inherit pnpm; };
          racket-minimal = pkgs.callPackage ./packages/racket-minimal/package.nix { };
          sbpf-linker = sbpf-linker-22;
          sbpf-linker-21 = pkgs.callPackage ./packages/sbpf-linker/package.nix { variant = "21"; };
          sbpf-linker-22 = pkgs.callPackage ./packages/sbpf-linker/package.nix { variant = "22"; };
          solana-verify = pkgs.callPackage ./packages/solana-verify/package.nix { };
          serverpod = serverpod_cli-3;
          serverpod-cli = serverpod_cli-3;
          serverpod_cli = serverpod_cli-3;
          serverpod_cli-3 = pkgs.callPackage ./packages/serverpod_cli-3/package.nix { };
          serverpod_cli-4 = pkgs.callPackage ./packages/serverpod_cli-4/package.nix { };
          steam = pkgs.callPackage ./packages/steam/package.nix { };
          surfpool = pkgs.callPackage ./packages/surfpool/package.nix { };
          wait-for-them = pkgs.callPackage ./packages/wait-for-them/package.nix { };
          zed = pkgs.callPackage ./packages/zed/package.nix { };
          zed-preview = pkgs.callPackage ./packages/zed-preview/package.nix { };
          zoom = pkgs.callPackage ./packages/zoom/package.nix { };
        };

        supportedPackages = lib.filterAttrs (
          _: pkg: lib.meta.availableOn pkgs.stdenv.hostPlatform pkg
        ) packages;

        allPkg = pkgs.symlinkJoin {
          name = "all-packages";
          paths = builtins.attrValues supportedPackages;
        };
      in
      {
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
              zizmor --offline --min-severity=high .github/workflows
              touch $out
            '';

        packages = packages // {
          all = allPkg;
          default = allPkg;
        };
      }
    );
}
