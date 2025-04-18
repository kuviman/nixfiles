{ config, pkgs, ... }: {
  home.pointerCursor = {
    enable = true;
    dotIcons.enable = true;
    hyprcursor.enable = true;
    x11.enable = true;
    gtk.enable = true;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-dark";
    size = 64;
  };
  gtk = {
    enable = true;
    cursorTheme.name = config.home.pointerCursor.name;
    cursorTheme.size = config.home.pointerCursor.size;
  };
}
