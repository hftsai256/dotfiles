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

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { flake-utils, ... } @ inputs:
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

    importPkgs = nixpkgs: system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.nixgl.overlay
        (import inputs.rust-overlay)
        (import ./overlays/gfx.nix)
        (import ./overlays/nvfetcher.nix)
        (import ./overlays/librime.nix)
      ];
    };

    mkHomeConfiguration = selectedPkgSrc: system: { username, modules, extraSpecialArgs ? {}, ... }:
      selectedPkgSrc.home-manager.lib.homeManagerConfiguration {
        pkgs = importPkgs selectedPkgSrc.nixpkgs system;

        extraSpecialArgs = {
          inherit (inputs) nixvim nixpkgs nixpkgs-unstable;
        } // extraSpecialArgs;

        modules = [
          { home = { inherit username stateVersion; homeDirectory = "/home/${username}"; }; }
          selectedPkgSrc.home-module
        ] ++ modules;
      };

    mkNixOS = selectedPkgSrc: { modules, specialArgs ? {}, ... }:
      selectedPkgSrc.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit (inputs) nixpkgs nixpkgs-unstable nixos-hardware lanzaboote impermanence;
        } // specialArgs;

        modules = [
          { system.stateVersion = stateVersion; }
          selectedPkgSrc.os-module
        ] ++ modules;
      };

  in
  flake-utils.lib.eachDefaultSystem (system: {
    packages.homeConfigurations = {
      "hftsai@rainberry" = mkHomeConfiguration pkgSrc.stable system {
        username = "hftsai";
        modules = [ ./users/hftsai-rainberry.nix ];
      };

      "hftsai@whiteforest" = mkHomeConfiguration pkgSrc.unstable system {
        username = "hftsai";
        modules = [ ./users/hftsai-whiteforest.nix ];
      };

      "hftsai@maplebright" = mkHomeConfiguration pkgSrc.unstable system {
        username = "hftsai";
        modules = [ ./users/hftsai-maplebright.nix ];
      };

      "deck@steamdeck" = mkHomeConfiguration pkgSrc.unstable system {
        username = "deck";
        modules = [ ./users/deck-steamdeck.nix ];
      };
    };
  }) // {
    nixosConfigurations = {
      rainberry = mkNixOS pkgSrc.stable {
        modules = [ ./hosts/rainberry/configuration.nix ];
      };

      whiteforest = mkNixOS pkgSrc.unstable {
        modules = [ ./hosts/whiteforest/configuration.nix ];
      };

      maplebright = mkNixOS pkgSrc.unstable {
        modules = [
          inputs.jovian.nixosModules.default
          ./hosts/maplebright/configuration.nix
	      ];
      };
    };
  };
}
