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

  outputs = { self, ... } @ inputs:
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

    mkStandaloneHome = {
      user,
      host,
      selectedPkgSrc ? pkgSrc.stable,
      system ? "x86_64-linux",
      homeModules ? [],
      extraSpecialArgs ? {},
      ...
    }:
    let
      username = user;
      homeDirectory = "/home/${user}";

    in
      selectedPkgSrc.home-manager.lib.homeManagerConfiguration {
        pkgs = importPkgs selectedPkgSrc.nixpkgs system;

        extraSpecialArgs = {
          inherit (inputs) nixvim;
        } // extraSpecialArgs;

        modules = [
          selectedPkgSrc.home-module
          ./users/${user}-${host}.nix
          { home = { inherit username homeDirectory stateVersion; }; }
        ] ++ homeModules;
      };

    mkNixosHomeModule = {
      user,
      host,
      homeModules ? [],
      extraSpecialArgs ? {},
      ...
    }:
    let
      username = user;
      homeDirectory = "/home/${user}";
      nixosConfig = self.nixosConfigurations.${host}.config;

    in
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          users.${user}.imports = [ 
            ./modules/home
            ./users/${user}-${host}.nix

            { config = with nixosConfig; {
                inherit hypr;
                home = { inherit username homeDirectory stateVersion; };
                fonts.fontconfig = { inherit (fonts.fontconfig) enable defaultFonts; };
            }; }
          ] ++ homeModules;

          extraSpecialArgs = { inherit (inputs) nixvim; } // extraSpecialArgs;
        };
      };

    mkNixOS = {
      host,
      regularUsers,
      selectedPkgSrc ? pkgSrc.stable,
      system ? "x86_64-linux",
      osModules ? [],
      homeModules ? [],
      specialArgs ? {},
      extraSpecialArgs ? {},
      ...
    }:
      selectedPkgSrc.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit (inputs) nixpkgs nixpkgs-unstable nixos-hardware lanzaboote impermanence;
        } // specialArgs;

        modules = [
          { system.stateVersion = stateVersion;
            nixpkgs.hostPlatform = system;
            nixpkgs.overlays = overlays;
          }

          selectedPkgSrc.os-module
          inputs.solaar.nixosModules.default
          ./hosts/${host}/configuration.nix

          selectedPkgSrc.home-manager.nixosModules.home-manager
        ] ++ (
          map (user: mkNixosHomeModule { inherit host user homeModules extraSpecialArgs; }) regularUsers
        ) ++ osModules;
      };

  in
  {
    nixosConfigurations = let
      defaultRegularUsers = [ "hftsai" ];

      machines = {
        rainberry = {
          regularUsers = defaultRegularUsers;
          selectedPkgSrc = pkgSrc.unstable;
        };

        whiteforest = {
          regularUsers = defaultRegularUsers;
        };

        maplebright = {
          regularUsers = defaultRegularUsers;
          selectedPkgSrc = pkgSrc.unstable;
          osModules = [ inputs.jovian.nixosModules.default ];
        };
      };

    in
      machines
      |> builtins.mapAttrs (host: attrs:
          mkNixOS ({ inherit host; } // attrs));


    homeConfigurations = let
      homes.deck = {
        host = "steamdeck";
        selectedPkgSrc = pkgSrc.unstable;
      };

    in
      homes
      |> builtins.mapAttrs (user: cfg: {
          name = "${user}@${cfg.host}";
          value = mkStandaloneHome ({ inherit user; } // cfg ); })
      |> builtins.attrValues
      |> builtins.listToAttrs;
  };
}
