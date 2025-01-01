# My XDG Dotfiles/Home Manager Configurations
## Quick Start
1. Clone this repository.
2. Simlink `home-manager` and other required folders under `xdg_config` to `$HOME/.config`.
3. Run the script `$HOME/.dotfiles/nix/scripts/nixhm-apply`
4. Select the proper config profile from the menu.
5. Run `nixhm-apply` as the command for future updates.
6. Profit! [^1]

[^1]: The script will check if `nix` has been installed in the system and will
invoke the Nix installation script from [Determinate Systems](https://determinate.systems/)
if necessary.

## Nix learning resources
* https://zero-to-nix.com/
* https://nixlang.wiki/
* https://ianthehenry.com/posts/how-to-learn-nix/
* https://leanpub.com/nixos-in-production#:~:text=About%20the%20Book,an%20organization%20to%20adopt%20NixOS%3F
* https://edolstra.github.io/pubs/phd-thesis.pdf

## Reference
* Courtasy to https://github.com/jbuchermn/dotfiles-nix/tree/main
