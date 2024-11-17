{ pkgs, ... }:
{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    size = 24;
    package = pkgs.simp1e-cursors;
    name = "Simp1e-Breeze";
  };

  qt.style.name = "breeze";

  gtk = {
    enable = true;

    theme = {
      package = pkgs.vimix-gtk-themes;
      name = "vimix-light-doder";
    };

    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela";
    };

    font = {
      name = "Noto Sans";
      size = 10;
    };
  };
}
