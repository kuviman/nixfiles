{ pkgs, ... }: {
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    wofi
    waybar
    hyprpaper
    hyprpicker
  ];

  xdg.portal.extraPortals = with pkgs; [
    (writeTextDir "/share/xdg-desktop-portal/portals/hyprland-portals.conf"
      ''
        [preferred]
        default=hyprland;gtk
      '')
  ];
}
