{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Do not follows nixpkgs: that changes the drv hash and misses noctalia.cachix.org.
    # https://docs.noctalia.dev/noctalia/getting-started/nixos/
    noctalia.url = "github:noctalia-dev/noctalia/v5.0.0-beta.10";

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    roland = {
      url = "github:hftsai256/roland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    stateVersion = "26.05";

    overlays = let
      unstablePkgs = system:
        import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
    in [
      inputs.nixgl.overlay
      inputs.niri.overlays.niri
      inputs.roland.overlays.default

      (import ./overlays/gfx.nix)
      (import ./overlays/libcamera.nix)

      # Steam and Hyprland always come from unstable; the rest of the system is 26.05.
      (final: prev: let
        upkgs = unstablePkgs prev.stdenv.hostPlatform.system;
      in {
        inherit (upkgs)
          steam
          steam-run
          steamPackages
          hyprland
          xdg-desktop-portal-hyprland
          hyprlandPlugins;
      })

      (import ./packages/overlay.nix)
    ];

    importPkgs = system:
      import inputs.nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

    mkStandaloneHome = {
      user,
      host,
      system ? "x86_64-linux",
      homeModules ? [],
      extraSpecialArgs ? {},
      ...
    }: let
      username = user;
      homeDirectory = "/home/${user}";
    in
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = importPkgs system;

        extraSpecialArgs = extraSpecialArgs;

        modules =
          [
            ./modules/home
            ./users/${user}-${host}.nix
            {home = {inherit username homeDirectory stateVersion;};}
          ]
          ++ homeModules;
      };

    mkNixosHomeModule = {
      host,
      user,
      homeModules ? [],
      extraSpecialArgs ? {},
      ...
    }: let
      username = user;
      homeDirectory = "/home/${user}";
      nixosConfig = self.nixosConfigurations.${host}.config;
    in {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        users.${user}.imports =
          [
            ./modules/home
            ./users/${user}-${host}.nix
            inputs.niri.homeModules.niri
            inputs.roland.homeModules.default
            inputs.noctalia.homeModules.default

            {
              config = with nixosConfig; {
                inherit hypr;
                home = {inherit username homeDirectory stateVersion;};
                fonts.fontconfig = {inherit (fonts.fontconfig) enable defaultFonts;};
              };
            }
          ]
          ++ homeModules;

        extraSpecialArgs =
          {
            inherit (nixosConfig) time;
          }
          // extraSpecialArgs;
      };
    };

    mkNixOS = {
      host,
      regularUsers,
      system ? "x86_64-linux",
      osModules ? [],
      homeModules ? [],
      specialArgs ? {},
      extraSpecialArgs ? {},
      ...
    }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs =
          {
            inherit (inputs) nixos-hardware lanzaboote impermanence;
          }
          // specialArgs;

        modules =
          [
            {
              system.stateVersion = stateVersion;
              nixpkgs.hostPlatform = system;
              nixpkgs.overlays = overlays;
            }

            ./modules/nixos
            ./hosts/${host}/configuration.nix

            inputs.home-manager.nixosModules.home-manager
            inputs.noctalia-greeter.nixosModules.default
          ]
          ++ (
            map (user:
              mkNixosHomeModule {
                inherit host user homeModules extraSpecialArgs;
              })
            regularUsers
          )
          ++ osModules;
      };
  in {
    nixosConfigurations = let
      defaultRegularUsers = ["hftsai"];

      machines = {
        aetherforge = {
          regularUsers = defaultRegularUsers;
          osModules = [inputs.disko.nixosModules.disko];
          homeModules = [];
          specialArgs = {
            installDrive = "/dev/nvme0n1";
            swapSize = "32G";
          };
        };

        CYT-HTSAI-LINUX = {
          regularUsers = defaultRegularUsers;
          homeModules = [];
        };

        maplebright = {
          regularUsers = defaultRegularUsers;
          homeModules = [];
        };
      };
    in
      machines
      |> builtins.mapAttrs (host: attrs:
        mkNixOS ({inherit host;} // attrs));

    homeConfigurations = let
      homes.deck = {
        host = "steamdeck";
      };
    in
      homes
      |> builtins.mapAttrs (user: cfg: {
        name = "${user}@${cfg.host}";
        value = mkStandaloneHome ({inherit user;} // cfg);
      })
      |> builtins.attrValues
      |> builtins.listToAttrs;
  };
}
