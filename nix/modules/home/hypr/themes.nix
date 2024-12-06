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
    platformTheme.name = "qtct";
    style.name = "adwaita";
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
    font = {
      name = "sans";
      size = 9;
    };
  };
}
