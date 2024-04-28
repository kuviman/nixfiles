{ pkgs, hostname, inputs, ... }:
{
  imports = [ inputs.hyprland.homeManagerModules.default ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    extraConfig =
      let
        monitors =
          if (hostname == "mainix") then ''
            monitor=DP-2,2560x1440@144,0x0,1
            monitor=HDMI-A-1,1920x1080@60,2560x180,1
            workspace=1, monitor:DP-2
            workspace=2, monitor:DP-2
            workspace=3, monitor:DP-2
            workspace=4, monitor:DP-2
            workspace=5, monitor:DP-2
            workspace=6, monitor:DP-2
            workspace=7, monitor:DP-2
            workspace=8, monitor:HDMI-A-1
            workspace=9, monitor:HDMI-A-1
            workspace=10, monitor:HDMI-A-1
          ''
          else if (hostname == "swiftix") then ''
            monitor=eDP-1,preferred,auto,1
          ''
          else "";
      in
      monitors + builtins.readFile ./hyprland.conf;
    plugins = [ inputs.Hyprspace.packages.${pkgs.system}.Hyprspace ];
  };
  home.file = {
    ".config/hypr/hyprpaper.conf".text =
      let wallpaper = pkgs.nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath;
      in ''
        preload = ${wallpaper}
        wallpaper = ,${wallpaper}
        ipc = off
        splash = false
      '';
    # TODO ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    ".config/waybar".source = ./waybar;
    ".config/wofi".source = ./wofi;
  };
}
