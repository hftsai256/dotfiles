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

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, flake-utils, ... } @ inputs:
  let
    stateVersion = "24.11";

    importPkgs = pkgSrc: system: import pkgSrc {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.nixgl.overlay
        (import ./overlays/gfx.nix)
        (import ./overlays/nvfetcher.nix)
        (import ./overlays/librime.nix)
      ];
    };

    mkHomeConfiguration = pkgSrc: system: { username, modules, extraSpecialArgs ? {}, ... }:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = importPkgs pkgSrc system;

        extraSpecialArgs = {
          inherit (inputs) nixvim;
        } // extraSpecialArgs;

        modules = [
          { home = { inherit username stateVersion; homeDirectory = "/home/${username}"; }; }
          ./modules/home
        ] ++ modules;
      };

    mkNixOS = pkgSrc: { modules, specialArgs ? {}, ... }:
      pkgSrc.lib.nixosSystem {
        specialArgs = {
          inherit (inputs) nixpkgs nixpkgs-unstable nixos-hardware lanzaboote impermanence;
        };

        modules = [
          { system.stateVersion = stateVersion; }
          ./modules/nixos
        ] ++ modules;
      };

  in
  flake-utils.lib.eachDefaultSystem (system: {
    packages.homeConfigurations = {
      "hftsai@rainberry" = mkHomeConfiguration nixpkgs system {
        username = "hftsai";
        modules = [ ./users/hftsai-rainberry.nix ];
      };

      "hftsai@rowanshade" = mkHomeConfiguration nixpkgs system {
        username = "hftsai";
        modules = [ ./users/hftsai-rowanshade.nix ];
      };

      "hftsai@maplebright" = mkHomeConfiguration nixpkgs system {
        username = "hftsai";
        modules = [ ./users/hftsai-maplebright.nix ];
      };

      "deck@steamdeck" = mkHomeConfiguration nixpkgs system {
        username = "deck";
        modules = [ ./users/deck-steamdeck.nix ];
      };
    };
  }) // {
    nixosConfigurations = {
      rainberry = mkNixOS nixpkgs {
        modules = [ ./hosts/rainberry/configuration.nix ];
      };

      rowanshade = mkNixOS nixpkgs {
        modules = [ ./hosts/rowanshade/configuration.nix ];
      };

      maplebright = mkNixOS nixpkgs-unstable {
        modules = [ ./hosts/maplebright/configuration.nix ];
      };
    };
  };
}
