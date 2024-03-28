{
  description = "My Home Manager configuration";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixgl, flake-utils, home-manager, nix-darwin, ... }:
  flake-utils.lib.eachDefaultSystem (
    system:
    let
      stateVersion = "23.11";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixgl.overlay
          (import ./overlays/nvfetcher.nix)
          (import ./overlays/kitty.nix)
          (import ./overlays/librime.nix)
        ];
      };

      homeManagerConfiguration = { modules, username, homeDirectory, extraSpecialArgs ? {} }: home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;

        modules = [
          { nix.registry.nixpkgs.flake = nixpkgs; }
          { home = { inherit username homeDirectory stateVersion; }; }
        ] ++ modules;
      };

      nixDarwinConfiguration = { modules, username, homeDirectory, extraSpecialArgs ? {} }: nix-darwin.lib.darwinSystem {};
    in {
      packages.homeManagerConfigurations = {
        work-xps13 = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/home/hftsai";

          modules = [ ./users/work-xps13.nix ];
        };

        personal-xps13 = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/home/hftsai";

          modules = [ ./users/personal.nix ];
        };

        personal-m1 = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/Users/hftsai";

          modules = [ ./users/personal.nix ];
        };

        personal-steamdeck = homeManagerConfiguration {
          username = "deck";
          homeDirectory = "/home/deck";

          modules = [ ./users/personal-steamdeck.nix ];
        };
      };
    }
  );
}
