# Dotfiles

Personal XDG-compliant dotfiles, Home Manager configurations, and NixOS system configs.

## Structure

| Path | Purpose |
|---|---|
| `nix/` | Home Manager modules, profiles, and shared settings |
| `scripts/` | Utility scripts, including `nixhm-apply` |
| `xdg_config/` | Config directories to symlink into `~/.config` |
| `ssh/`, `wallpapers/` | Supporting resources |

## Usage

### NixOS

Import from `nix/` into your system flake and reference the relevant Home Manager profile under `home-manager.users.<name>`. Then rebuild:

```bash
sudo nixos-rebuild switch --flake /path/to/your-flake#hostname
```

Do **not** run `nixhm-apply` on NixOS.

### Non-NixOS (SteamOS, macOS, WSL, Arch, etc.)

See [HOME_MANAGER.md](./HOME_MANAGER.md). In short:

```bash
git clone https://git.htwillows.net/hftsai256/dotfiles.git ~/.dotfiles
~/.dotfiles/nix/scripts/nixhm-apply
```

The script installs Nix if needed, then presents a profile menu.

## Docs

- [HOME_MANAGER.md](./HOME_MANAGER.md) - Standalone Home Manager on non-NixOS hosts
- [NIX_OS.md](./NIX_OS.md) - Fresh NixOS install (disko + nixos-anywhere, or manual LUKS/Btrfs)

## License

MIT
