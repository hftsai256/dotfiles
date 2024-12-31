{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    flake-utils.url = "github:numtide/flake-utils";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, flake-utils, ... } @ inputs:
  flake-utils.lib.eachDefaultSystem (system:
    let
      stateVersion = "24.11";

      importPkgs = pkgSrc: import pkgSrc {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nixgl.overlay
          (import ./overlays/gfx.nix)
          (import ./overlays/nvfetcher.nix)
          (import ./overlays/librime.nix)
        ];
      };

      pkgs = importPkgs nixpkgs;

      homeManagerConfiguration = { modules, username, homeDirectory, extraSpecialArgs ? {}, ... }:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit (inputs) pkgsUnstable nixvim;
          } // extraSpecialArgs;

          modules = [
            { home = { inherit username homeDirectory stateVersion; }; }
            ./modules/home
          ] ++ modules;
        };

    in {
      packages.homeConfigurations = {
        "hftsai@rainberry" = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/home/hftsai";
          modules = [ ./users/hftsai-rainberry.nix ];
        };

        "hftsai@rowanshade" = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/home/hftsai";
          modules = [ ./users/hftsai-rowanshade.nix ];
        };

        "deck@steamdeck" = homeManagerConfiguration {
          username = "deck";
          homeDirectory = "/home/deck";
          modules = [ ./users/deck-steamdeck.nix ];
        };
      };
    }
  ) // {
    nixosConfigurations = {
      rainberry = nixpkgs.lib.nixosSystem {
        specialArgs = with inputs; { 
          inherit nixpkgs-unstable nixos-hardware lanzaboote impermanence;
        };
        modules = [
          ./hosts/rainberry/configuration.nix
        ];
      };
      rowanshade = nixpkgs.lib.nixosSystem {
        specialArgs = with inputs; {
          inherit nixpkgs-unstable nixos-hardware lanzaboote impermanence;
        };
        modules = [
          ./hosts/rowanshade/configuration.nix
        ];
      };
    };
  };
}
