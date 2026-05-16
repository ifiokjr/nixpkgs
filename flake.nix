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
        agave = final.callPackage ./packages/agave/package.nix { };
        agave-2_0 = final.callPackage ./packages/agave-2_0/package.nix { };
        agave-2_1 = final.callPackage ./packages/agave-2_1/package.nix { };
        agave-2_2 = final.callPackage ./packages/agave-2_2/package.nix { };
        agave-2_3 = final.callPackage ./packages/agave-2_3/package.nix { };
        agave-3_0 = final.callPackage ./packages/agave-3_0/package.nix { };
        agave-3_1 = final.callPackage ./packages/agave-3_1/package.nix { };
        agave-4_0 = final.callPackage ./packages/agave-4_0/package.nix { };
        cargo-clean-all = final.callPackage ./packages/cargo-clean-all/package.nix { };
        dylint = final.callPackage ./packages/dylint/package.nix { };
        cargo-interactive-update = final.callPackage ./packages/cargo-interactive-update/package.nix { };
        codex-cli = final.callPackage ./packages/codex-cli/package.nix { };
        deno = final.callPackage ./packages/deno/package.nix { };
        godot = final.callPackage ./packages/godot/package.nix { };
        gpg-suite = final.callPackage ./packages/gpg-suite/package.nix { };
        ironclaw = final.callPackage ./packages/ironclaw/package.nix { };
        kani = final.callPackage ./packages/kani/package.nix { };
        knope = final.callPackage ./packages/knope/package.nix { };
        mdt = final.callPackage ./packages/mdt/package.nix { };
        monochange = final.callPackage ./packages/monochange/package.nix { };
        nordvpn = final.callPackage ./packages/nordvpn/package.nix { };
        ollama = final.callPackage ./packages/ollama/package.nix { };
        pina = final.callPackage ./packages/pina/package.nix { };
        pnpm = final.callPackage ./packages/pnpm/package.nix { };
        pnpm-10 = final.callPackage ./packages/pnpm-10/package.nix { };
        pnpm-11 = final.callPackage ./packages/pnpm-11/package.nix { };
        pnpm-standalone = final.callPackage ./packages/pnpm-standalone/package.nix { inherit pnpm; };
        racket-minimal = final.callPackage ./packages/racket-minimal/package.nix { };
        sbpf-linker = final.callPackage ./packages/sbpf-linker/package.nix { };
        solana-verify = final.callPackage ./packages/solana-verify/package.nix { };
        steam = final.callPackage ./packages/steam/package.nix { };
        surfpool = final.callPackage ./packages/surfpool/package.nix { };
        wait-for-them = final.callPackage ./packages/wait-for-them/package.nix { };
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
          agave = pkgs.callPackage ./packages/agave/package.nix { };
          agave-2_0 = pkgs.callPackage ./packages/agave-2_0/package.nix { };
          agave-2_1 = pkgs.callPackage ./packages/agave-2_1/package.nix { };
          agave-2_2 = pkgs.callPackage ./packages/agave-2_2/package.nix { };
          agave-2_3 = pkgs.callPackage ./packages/agave-2_3/package.nix { };
          agave-3_0 = pkgs.callPackage ./packages/agave-3_0/package.nix { };
          agave-3_1 = pkgs.callPackage ./packages/agave-3_1/package.nix { };
          agave-4_0 = pkgs.callPackage ./packages/agave-4_0/package.nix { };
          cargo-clean-all = pkgs.callPackage ./packages/cargo-clean-all/package.nix { };
          dylint = pkgs.callPackage ./packages/dylint/package.nix { };
          cargo-interactive-update = pkgs.callPackage ./packages/cargo-interactive-update/package.nix { };
          codex-cli = pkgs.callPackage ./packages/codex-cli/package.nix { };
          deno = pkgs.callPackage ./packages/deno/package.nix { };
          godot = pkgs.callPackage ./packages/godot/package.nix { };
          gpg-suite = pkgs.callPackage ./packages/gpg-suite/package.nix { };
        ironclaw = pkgs.callPackage ./packages/ironclaw/package.nix { };
          kani = pkgs.callPackage ./packages/kani/package.nix { };
          knope = pkgs.callPackage ./packages/knope/package.nix { };
          mdt = pkgs.callPackage ./packages/mdt/package.nix { };
          monochange = pkgs.callPackage ./packages/monochange/package.nix { };
          nordvpn = pkgs.callPackage ./packages/nordvpn/package.nix { };
          ollama = pkgs.callPackage ./packages/ollama/package.nix { };
          pina = pkgs.callPackage ./packages/pina/package.nix { };
          pnpm = pkgs.callPackage ./packages/pnpm/package.nix { };
          pnpm-10 = pkgs.callPackage ./packages/pnpm-10/package.nix { };
          pnpm-11 = pkgs.callPackage ./packages/pnpm-11/package.nix { };
          pnpm-standalone = pkgs.callPackage ./packages/pnpm-standalone/package.nix { inherit pnpm; };
          racket-minimal = pkgs.callPackage ./packages/racket-minimal/package.nix { };
          sbpf-linker = pkgs.callPackage ./packages/sbpf-linker/package.nix { };
          solana-verify = pkgs.callPackage ./packages/solana-verify/package.nix { };
          steam = pkgs.callPackage ./packages/steam/package.nix { };
          surfpool = pkgs.callPackage ./packages/surfpool/package.nix { };
          wait-for-them = pkgs.callPackage ./packages/wait-for-them/package.nix { };
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
        packages = packages // {
          all = allPkg;
          default = allPkg;
        };
      }
    );
}
