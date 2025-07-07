{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim-stable = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim-unstable = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-pkgs.url = "github:hyprwm/Hyprland";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
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
    stateVersion = "25.05";

    pkgSrc = {
      stable = {
        nixpkgs = inputs.nixpkgs;
        home-manager = inputs.home-manager;
        os-module = ./modules/nixos;
        home-module = ./modules/home;
        nixvim = inputs.nixvim-stable;
      };

      unstable = {
        nixpkgs = inputs.nixpkgs-unstable;
        home-manager = inputs.home-manager-unstable;
        os-module = ./modules/nixos-unstable;
        home-module = ./modules/home;
        nixvim = inputs.nixvim-unstable;
      };
    };

    overlays = [
      inputs.nixgl.overlay
      inputs.niri.overlays.niri
      (import ./overlays/gfx.nix)
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
          inherit (selectedPkgSrc) nixvim;
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
      selectedPkgSrc ? pkgSrc.stable,
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
                inherit hypr niri;
                home = { inherit username homeDirectory stateVersion; };
                fonts.fontconfig = { inherit (fonts.fontconfig) enable defaultFonts; };
            }; }
          ] ++ homeModules;

          extraSpecialArgs = { inherit (selectedPkgSrc) nixvim; } // extraSpecialArgs;
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
          inherit (inputs) nixpkgs nixpkgs-unstable nixos-hardware lanzaboote impermanence hyprland-pkgs;
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
          map (user: mkNixosHomeModule { inherit host user homeModules selectedPkgSrc extraSpecialArgs; }) regularUsers
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
          homeModules = [ inputs.niri.homeModules.niri ];
        };

        whiteforest = {
          regularUsers = defaultRegularUsers;
          selectedPkgSrc = pkgSrc.unstable;
          homeModules = [ inputs.niri.homeModules.niri ];
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
