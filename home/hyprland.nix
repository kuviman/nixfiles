{ config, pkgs, hostname, inputs, system, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      input.sensitivity = if hostname == "mainix" then -1.0 else 0;

      # https://github.com/nix-community/home-manager/issues/2659
      envd = with builtins; attrValues
        (mapAttrs
          (name: value: "${name}, ${toString value}")
          config.home.sessionVariables
        ) ++ [
        # "EXTRA_VARIABLE, 1"
      ];

    };
    env = [
      "XCURSOR_THEME,${config.home.pointerCursor.name}"
      "XCURSOR_SIZE,${config.home.pointerCursor.size}"
      "HYPRCURSOR_THEME,${config.home.pointerCursor.name}"
      "HYPRCURSOR_SIZE,${config.home.pointerCursor.size}"
    ];
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
  };
  home.file = {
    ".config/hypr/hyprpaper.conf".text =
      let
        # wallpaper = ../wallpapers/ludumdare56.png;
        wallpaper = pkgs.nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath;
      in
      ''
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
