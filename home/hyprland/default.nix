{ config, pkgs, hostname, inputs, system, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # https://github.com/nix-community/home-manager/issues/2659
      env = with builtins; attrValues
        (mapAttrs
          (name: value: { _args = [ name (toString value) ]; })
          config.home.sessionVariables
        ) ++ [
        { _args = [ "XCURSOR_THEME" config.home.pointerCursor.name ]; }
        { _args = [ "XCURSOR_SIZE" (toString config.home.pointerCursor.size) ]; }
        { _args = [ "HYPRCURSOR_THEME" config.home.pointerCursor.name ]; }
        { _args = [ "HYPRCURSOR_SIZE" (toString config.home.pointerCursor.size) ]; }
      ];
    };
    extraConfig = builtins.readFile ./hyprland.lua;
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
