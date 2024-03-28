{
  description = "My Home Manager configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # I have no idea what I'm doing. Peeking into its source,
    # seems like it provides nix-darwin and home-manager input sources
    # so that I can hook them up in the output section below without
    # explicitly define their URLs here.
    nix.url = "https://flakehub.com/f/DeterminateSystems/nix/2.0";

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { nixpkgs, nixgl, flake-utils, home-manager, nix-darwin, ... } @ inputs:
  flake-utils.lib.eachDefaultSystem (system:
    let
      stateVersion = "23.11";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          nixgl.overlay
          (import ./overlays/pkgsource.nix)
          (import ./overlays/nvfetcher.nix)
          (import ./overlays/librime.nix)
        ];
      };

      homeManagerConfiguration = { modules, username, homeDirectory, extraSpecialArgs ? {} }: home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;

        modules = [
          inputs.nix.homeManagerModules.default
          { home = { inherit username homeDirectory stateVersion; }; }
          ./modules/home.nix
        ] ++ modules;
      };

      nixDarwinConfiguration = { modules, username, homeDirectory, extraSpecialArgs ? {} }: nix-darwin.lib.darwinSystem {
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
          extraSpecialArgs = { pkgsource = "null"; };
        };

        personal-xps13 = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/home/hftsai";

          modules = [ ./users/personal.nix ];
          extraSpecialArgs = { pkgsource = "null"; };
        };

        personal-m1 = homeManagerConfiguration {
          username = "hftsai";
          homeDirectory = "/Users/hftsai";

          modules = [ ./users/personal.nix ];
          extraSpecialArgs = { pkgsource = "darwin"; };
        };

        personal-steamdeck = homeManagerConfiguration {
          username = "deck";
          homeDirectory = "/home/deck";

          modules = [ ./users/personal-steamdeck.nix ];
          extraSpecialArgs = { pkgsource = "nixgl"; };
        };
      };
    }
  );
}
