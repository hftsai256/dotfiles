{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko-unstable = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote-unstable = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim-stable = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim-unstable = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-unstable = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl-unstable = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, ... } @ inputs:
  let
    stateVersion = "26.05";

    pkgSrc = {
      stable = {
        nixpkgs = inputs.nixpkgs;
        disko = inputs.disko;
        lanzaboote = inputs.lanzaboote;
        home-manager = inputs.home-manager;
        nixvim = inputs.nixvim-stable;
        niri = inputs.niri;
        noctalia = inputs.noctalia;
        nixgl = inputs.nixgl;
        os-module = ./modules/nixos;
        home-module = ./modules/home;
      };

      unstable = {
        nixpkgs = inputs.nixpkgs-unstable;
        disko = inputs.disko-unstable;
        lanzaboote = inputs.lanzaboote-unstable;
        home-manager = inputs.home-manager-unstable;
        niri = inputs.niri-unstable;
        noctalia = inputs.noctalia;
        nixvim = inputs.nixvim-unstable;
        nixgl = inputs.nixgl-unstable;
        os-module = ./modules/nixos-unstable;
        home-module = ./modules/home;
      };
    };

    selectOverlays = selectedPkgSrc: [
      selectedPkgSrc.nixgl.overlay
      selectedPkgSrc.niri.overlays.niri
      selectedPkgSrc.noctalia.overlays.default
      (import ./overlays/gfx.nix)
      (import ./overlays/libcamera.nix)
      (import ./packages/overlay.nix)
    ];

    importPkgs = selectedPkgSrc: system: import selectedPkgSrc.nixpkgs {
      inherit system;
      overlays = selectOverlays selectedPkgSrc;
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
        pkgs = importPkgs selectedPkgSrc system;

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
      host,
      user,
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
            selectedPkgSrc.niri.homeModules.niri
            selectedPkgSrc.noctalia.homeModules.default

            { config = with nixosConfig; {
                inherit hypr;
                home = { inherit username homeDirectory stateVersion; };
                fonts.fontconfig = { inherit (fonts.fontconfig) enable defaultFonts; };
            }; }
          ] ++ homeModules;

          extraSpecialArgs = {
            inherit (selectedPkgSrc) nixvim;
          } // extraSpecialArgs;
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
            nixpkgs.overlays = selectOverlays selectedPkgSrc;
          }

          selectedPkgSrc.os-module
          ./hosts/${host}/configuration.nix

          selectedPkgSrc.home-manager.nixosModules.home-manager
        ] ++ (
          map (user: mkNixosHomeModule {
            inherit host user homeModules selectedPkgSrc extraSpecialArgs;
          }) regularUsers
        ) ++ osModules;
      };

  in
  {
    nixosConfigurations = let
      defaultRegularUsers = [ "hftsai" ];

      machines = {
        aetherforge = {
          regularUsers = defaultRegularUsers;
          selectedPkgSrc = pkgSrc.unstable;
          osModules = with pkgSrc.unstable; [ disko.nixosModules.disko ];
          homeModules = [];
          specialArgs = { installDrive = "/dev/nvme0n1"; swapSize = "32G"; };
        };

        CYT-HTSAI-LINUX = {
          regularUsers = defaultRegularUsers;
          selectedPkgSrc = pkgSrc.unstable;
          homeModules = [];
        };

        maplebright = {
          regularUsers = defaultRegularUsers;
          selectedPkgSrc = pkgSrc.unstable;
          homeModules = [];
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
