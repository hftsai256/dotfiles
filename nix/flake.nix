{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { nixpkgs, flake-utils, ... } @ inputs:
  flake-utils.lib.eachDefaultSystem (system:
    let
      stateVersion = "24.11";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nixgl.overlay
          (import ./overlays/glsource.nix)
          (import ./overlays/nvfetcher.nix)
          (import ./overlays/librime.nix)
        ];
      };

      homeManagerConfiguration = { modules, username, homeDirectory, extraSpecialArgs ? {}, ... }:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit (inputs) nixvim;
          } // extraSpecialArgs;

          modules = [
            { home = { inherit username homeDirectory stateVersion; }; }
            ./modules/home/home.nix
          ] ++ modules;
        };

    in {
      packages.homeManagerConfigurations = {
        work-xps13 = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/home/hftsai";

          modules = [ ./users/work-xps13.nix ];
          extraSpecialArgs = {
            glSource = "null";
            term.name = "kitty";
          };
        };

        personal-xps13 = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/home/hftsai";
          modules = [ 
            ./users/personal-xps13.nix
          ];
          extraSpecialArgs = { 
            glSource = "native";
            term.name = "kitty";
          };
        };

        personal-steamdeck = homeManagerConfiguration {
          username = "deck";
          homeDirectory = "/home/deck";

          modules = [ ./users/personal-steamdeck.nix ];
          extraSpecialArgs = {
            glSource = "nixgl";
            term.name = "kitty";
          };
        };
      };
    }
  ) // {
    nixosConfigurations = {
      hft-xps9370 = nixpkgs.lib.nixosSystem {
        specialArgs = with inputs; { 
          inherit nixos-hardware;
        };
        modules = [
          ./hosts/hft-xps9370/configuration.nix
        ];
      };
    };
  };
}
