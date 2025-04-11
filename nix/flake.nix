{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { ... } @ inputs:
  let
    stateVersion = "24.11";

    pkgSrc = {
      stable = {
        nixpkgs = inputs.nixpkgs;
        home-manager = inputs.home-manager;
        os-module = ./modules/nixos;
        home-module = ./modules/home;
      };

      unstable = {
        nixpkgs = inputs.nixpkgs-unstable;
        home-manager = inputs.home-manager-unstable;
        os-module = ./modules/nixos-unstable;
        home-module = ./modules/home;
      };
    };

    overlays = [
      inputs.nixgl.overlay
      (import inputs.rust-overlay)
      (import ./overlays/gfx.nix)
      (import ./overlays/nvfetcher.nix)
      (import ./overlays/librime.nix)
    ];

    importPkgs = nixpkgs: system: import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    mkHomeConfiguration = {
      selectedPkgSrc ? pkgSrc.stable,
      system ? "x86_64-linux",
      username,
      modules,
      extraSpecialArgs ? {},
      ...
    }:
    let
      homeDirectory = "/home/${username}";

    in
      selectedPkgSrc.home-manager.lib.homeManagerConfiguration {
        pkgs = importPkgs selectedPkgSrc.nixpkgs system;

        extraSpecialArgs = {
          inherit (inputs) nixvim nixpkgs nixpkgs-unstable;
        } // extraSpecialArgs;

        modules = [
          { home = { inherit username homeDirectory stateVersion; }; }
          selectedPkgSrc.home-module
        ] ++ modules;
      };

    mkHomeModule = {
      username,
      host,
      modules ? [],
      extraSpecialArgs ? {},
      ...
    }:
    let
      homeDirectory = "/home/${username}";

    in
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          users.${username}.imports = [ 
            ./modules/home
            ./users/${username}-${host}.nix
            { home = { inherit stateVersion username homeDirectory; };}
          ] ++ modules;

          extraSpecialArgs = { inherit (inputs) nixvim; } // extraSpecialArgs;
        };
      };

    mkNixOS = {
      selectedPkgSrc ? pkgSrc.stable,
      system ? "x86_64-linux",
      modules ? [],
      specialArgs ? {},
      ...
    }:
      selectedPkgSrc.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit (inputs) nixpkgs nixpkgs-unstable nixos-hardware lanzaboote impermanence;
        } // specialArgs;

        modules = [
          {
            system.stateVersion = stateVersion;
            nixpkgs.hostPlatform = system;
            nixpkgs.overlays = overlays;
          }

          selectedPkgSrc.os-module
          inputs.solaar.nixosModules.default
        ] ++ modules;
      };

  in
  {
    packages."x86_64-linux".homeConfigurations = {
      "hftsai@rainberry" = mkHomeConfiguration {
        username = "hftsai";
        modules = [ ./users/hftsai-rainberry.nix ];
      };

      "hftsai@whiteforest" = mkHomeConfiguration {
        username = "hftsai";
        modules = [ ./users/hftsai-whiteforest.nix ];
      };

      "hftsai@maplebright" = mkHomeConfiguration {
        selectedPkgSrc = pkgSrc.unstable;
        username = "hftsai";
        modules = [ ./users/hftsai-maplebright.nix ];
      };

      "deck@steamdeck" = mkHomeConfiguration {
        username = "deck";
        modules = [ ./users/deck-steamdeck.nix ];
      };
    };

    nixosConfigurations = {
      rainberry = mkNixOS rec {
        selectedPkgSrc = pkgSrc.unstable;

        modules = [ 
          ./hosts/rainberry/configuration.nix

          selectedPkgSrc.home-manager.nixosModules.home-manager (
            mkHomeModule { username = "hftsai"; host = "rainberry"; })
        ];
      };

      whiteforest = mkNixOS rec {
        selectedPkgSrc = pkgSrc.stable;

        modules = [ 
          ./hosts/whiteforest/configuration.nix

          selectedPkgSrc.home-manager.nixosModules.home-manager (
            mkHomeModule { username = "hftsai"; host = "whiteforest"; })
        ];
      };

      maplebright = mkNixOS rec {
        selectedPkgSrc = pkgSrc.unstable;

        modules = [
          inputs.jovian.nixosModules.default
          ./hosts/maplebright/configuration.nix

          selectedPkgSrc.home-manager.nixosModules.home-manager (
            mkHomeModule { username = "hftsai"; host = "maplebright"; })
	      ];
      };
    };
  };
}
