{ pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    size = 24;
    package = pkgs.simp1e-cursors;
    name = "Simp1e-Breeze";
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.vimix-gtk-themes;
      name = "vimix-light-doder";
    };
    iconTheme = {
      package = pkgs.vimix-icon-theme;
      name = "Vimix-Doder";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = "Source Sans Pro 10, Source Han Sans 9";
      monospace-font-name = "Fira Code 10, Symbols Nerd Font 9";
    };
  };

}
