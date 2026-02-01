{ config, pkgs, hostname, inputs, system, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # https://github.com/nix-community/home-manager/issues/2659
      envd = with builtins; attrValues
        (mapAttrs
          (name: value: "${name}, ${toString value}")
          config.home.sessionVariables
        ) ++ [
        # "EXTRA_VARIABLE, 1"
      ];

      env = [
        "XCURSOR_THEME,${config.home.pointerCursor.name}"
        "XCURSOR_SIZE,${builtins.toString config.home.pointerCursor.size}"
        "HYPRCURSOR_THEME,${config.home.pointerCursor.name}"
        "HYPRCURSOR_SIZE,${builtins.toString config.home.pointerCursor.size}"
      ];
    };
    extraConfig =
      let
        monitors = "exec = bash ${./monitors.sh}\n";
      in
      monitors + builtins.readFile ./hyprland.conf;
  };
  home.packages = with pkgs; [
    jq
  ];
  home.file = {
    ".config/hypr/hyprpaper.conf".text =
      let
        wallpaper = pkgs.nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath;
      in
      ''
        wallpaper {
            monitor =
            path = ${wallpaper}
        }
        ipc = off
        splash = false
      '';
    # ".config/waybar".source = ./waybar;
    ".config/wofi".source = ../wofi;
  };
}
