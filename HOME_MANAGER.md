# Standalone Home Manager – Non-NixOS Systems

Apply user-level configurations from this repository on hosts where Nix is used as a standalone package manager (not NixOS).

**Supported platforms**  
- SteamOS / Steam Deck  
- macOS  
- WSL  
- Arch, Fedora, Ubuntu, etc.

### Steps

1. **Clone the repository**

   ```bash
   git clone https://git.htwillows.net/hftsai256/dotfiles.git ~/.dotfiles
   ```

2. **Symlink XDG configurations**

   Link desired directories from `xdg_config/` to `~/.config`:

   ```bash
   ln -s ~/.dotfiles/xdg_config/* ~/.config/
   ```

   Adjust symlinks based on your chosen profile and platform.

3. **Activate configuration**

   Run the provided script:

   ```bash
   ~/.dotfiles/nix/scripts/nixhm-apply
   ```

   - If Nix is not installed, the script automatically installs it via the Determinate Systems installer.
   - Select your desired profile from the menu.
   - Home Manager installs packages, links dotfiles, and activates the environment.

4. **Future updates**

   Re-run:

   ```bash
   nixhm-apply
   ```

### Platform Notes

- **Steam Deck**: Nix persists across SteamOS updates; use for user packages and dotfiles.
- **macOS**: Works with standalone Nix; consider nix-darwin for deeper integration if desired.
- **WSL**: Multi-user Nix recommended; GUI support may need WSLg or X server.

**Important**: This script is **only** for non-NixOS hosts. On NixOS, import the repository contents into your system configuration and activate via `nixos-rebuild switch` (see [NIX_OS.md](./NIX_OS.md)).
