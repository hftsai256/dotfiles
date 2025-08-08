# Dotfiles

Personal XDG-compliant dotfiles and Home Manager configurations for managing user environments across work and personal machines.

## Overview

- Primary languages: Nix ≈49%, Shell ≈47%, CSS ≈3%
- Focus: Declarative user-level configuration via Home Manager
- Core components:
  - `nix/`               — Home Manager modules, profiles, and shared settings
  - `scripts/`           — Utility scripts, including `nixhm-apply` for standalone activation
  - `xdg_config/`        — Configuration directories to symlink into `~/.config`
  - `ssh/`, `wallpapers/` — Supporting resources

This repository does **not** contain full NixOS system configurations (no flake.nix, configuration.nix, etc.). It manages **user environments only**.

## Usage

### On NixOS

Import the desired parts of this repository (typically from the `nix/` directory) into your **own** system configuration:

- Reference the relevant Home Manager profile/module in your `home-manager.users.<yourname>` block.
- Rebuild the system:

  ```bash
  sudo nixos-rebuild switch --flake /path/to/your/system-flake#hostname
  ```

  or (legacy path):

  ```bash
  sudo nixos-rebuild switch
  ```

The user environment activates automatically as part of system activation. Do **not** run `nixhm-apply` on NixOS — it is intended only for standalone Home Manager on non-NixOS hosts.

### On non-NixOS hosts

Follow the instructions in [HOME_MANAGER.md](./HOME_MANAGER.md) to apply configurations via the `nixhm-apply` script.

## Documentation

- [NIX_OS.md](./NIX_OS.md) — Manual steps for a fresh NixOS installation (LUKS + tmpfs root + Btrfs subvolumes)
- [HOME_MANAGER.md](./HOME_MANAGER.md) — Standalone Home Manager setup on non-NixOS systems

## License

MIT (or replace with your preferred license)
