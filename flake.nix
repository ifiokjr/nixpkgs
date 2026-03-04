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
      overlays.default = final: _prev: {
        agave = final.callPackage ./packages/agave/package.nix { };
        cargo-interactive-update = final.callPackage ./packages/cargo-interactive-update/package.nix { };
        codex-cli = final.callPackage ./packages/codex-cli/package.nix { };
        codexbar = final.callPackage ./packages/codexbar/package.nix { };
        cursor-cli = final.callPackage ./packages/cursor-cli/package.nix { };
        google-drive = final.callPackage ./packages/google-drive/package.nix { };
        gpg-suite = final.callPackage ./packages/gpg-suite/package.nix { };
        knope = final.callPackage ./packages/knope/package.nix { };
        mdt = final.callPackage ./packages/mdt/package.nix { };
        nordvpn = final.callPackage ./packages/nordvpn/package.nix { };
        pina = final.callPackage ./packages/pina/package.nix { };
        pnpm-standalone = final.callPackage ./packages/pnpm-standalone/package.nix { };
        racket-minimal = final.callPackage ./packages/racket-minimal/package.nix { };
        steam = final.callPackage ./packages/steam/package.nix { };
        surfpool = final.callPackage ./packages/surfpool/package.nix { };
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

        packages = {
          agave = pkgs.callPackage ./packages/agave/package.nix { };
          cargo-interactive-update = pkgs.callPackage ./packages/cargo-interactive-update/package.nix { };
          codex-cli = pkgs.callPackage ./packages/codex-cli/package.nix { };
          codexbar = pkgs.callPackage ./packages/codexbar/package.nix { };
          cursor-cli = pkgs.callPackage ./packages/cursor-cli/package.nix { };
          google-drive = pkgs.callPackage ./packages/google-drive/package.nix { };
          gpg-suite = pkgs.callPackage ./packages/gpg-suite/package.nix { };
          knope = pkgs.callPackage ./packages/knope/package.nix { };
          mdt = pkgs.callPackage ./packages/mdt/package.nix { };
          nordvpn = pkgs.callPackage ./packages/nordvpn/package.nix { };
          pina = pkgs.callPackage ./packages/pina/package.nix { };
          pnpm-standalone = pkgs.callPackage ./packages/pnpm-standalone/package.nix { };
          racket-minimal = pkgs.callPackage ./packages/racket-minimal/package.nix { };
          steam = pkgs.callPackage ./packages/steam/package.nix { };
          surfpool = pkgs.callPackage ./packages/surfpool/package.nix { };
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
