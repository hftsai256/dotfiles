{
  description = "My Home Manager configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix.url = "https://flakehub.com/f/DeterminateSystems/nix/2.0";

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

  outputs = { nixpkgs, nixvim, nixgl, flake-utils, home-manager, nix-darwin, ... } @ inputs:
  flake-utils.lib.eachDefaultSystem (system:
    let
      stateVersion = "24.05";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixgl.overlay
          (import ./overlays/glsource.nix)
          (import ./overlays/nvfetcher.nix)
          (import ./overlays/librime.nix)
        ];
      };

      homeManagerConfiguration = { modules, username, homeDirectory, extraSpecialArgs ? {} }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit nixvim;
          } // extraSpecialArgs;

          modules = [
            { home = { inherit username homeDirectory stateVersion; }; }
            ./modules/home.nix
          ] ++ modules;
        };

      nixDarwinConfiguration = { modules, username, homeDirectory, extraSpecialArgs ? {} }:
        nix-darwin.lib.darwinSystem {
          inherit pkgs extraSpecialArgs;

          modules = [
            inputs.nix.darwinModules.default
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

        work-headless = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/home/hftsai";

          modules = [ ./users/work-headless.nix ];
          extraSpecialArgs = {
            glSource = "null";
          };
        };

        personal-xps13 = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/home/hftsai";

          modules = [ ./users/personal.nix ];
          extraSpecialArgs = { glSource = "null"; };
        };

        personal-m1 = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/Users/hftsai";

          modules = [ ./users/personal-m1.nix ];
          extraSpecialArgs = { 
            glSource = "darwin";
            term.name = "kitty";
            term.font = {
              name = "monospace";
              size = 11;
            };
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
  );
}
