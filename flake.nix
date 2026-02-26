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
      overlays.default =
        final: _prev:
        {
          codex-cli = final.callPackage ./packages/codex-cli/package.nix { };
          cursor-cli = final.callPackage ./packages/cursor-cli/package.nix { };
          google-chrome = final.callPackage ./packages/google-chrome/package.nix { };
          google-drive = final.callPackage ./packages/google-drive/package.nix { };
          gpg-suite = final.callPackage ./packages/gpg-suite/package.nix { };
          knope = final.callPackage ./packages/knope/package.nix { };
          mdt = final.callPackage ./packages/mdt/package.nix { };
          nordvpn = final.callPackage ./packages/nordvpn/package.nix { };
          pnpm-standalone = final.callPackage ./packages/pnpm-standalone/package.nix { };
          racket-minimal = final.callPackage ./packages/racket-minimal/package.nix { };
          steam = final.callPackage ./packages/steam/package.nix { };
          zoom = final.callPackage ./packages/zoom/package.nix { };
        };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = pkgs.lib;

        packages = {
          codex-cli = pkgs.callPackage ./packages/codex-cli/package.nix { };
          cursor-cli = pkgs.callPackage ./packages/cursor-cli/package.nix { };
          google-chrome = pkgs.callPackage ./packages/google-chrome/package.nix { };
          google-drive = pkgs.callPackage ./packages/google-drive/package.nix { };
          gpg-suite = pkgs.callPackage ./packages/gpg-suite/package.nix { };
          knope = pkgs.callPackage ./packages/knope/package.nix { };
          mdt = pkgs.callPackage ./packages/mdt/package.nix { };
          nordvpn = pkgs.callPackage ./packages/nordvpn/package.nix { };
          pnpm-standalone = pkgs.callPackage ./packages/pnpm-standalone/package.nix { };
          racket-minimal = pkgs.callPackage ./packages/racket-minimal/package.nix { };
          steam = pkgs.callPackage ./packages/steam/package.nix { };
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
