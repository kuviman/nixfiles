{ pkgs, lib, config, inputs, ... }:

{
  options = {
    kuviman.hyprland.enable = lib.mkOption
      {
        type = lib.types.bool;
        default = false;
      };
  };
  config = lib.mkIf config.kuviman.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    xdg.portal.wlr.enable = lib.mkForce true; # Or conflict with sway
    environment.systemPackages = with pkgs; [
      waybar
      hyprpaper
      hyprpicker
      hyprshot
      mako # notifications
      wofi
      pavucontrol
    ];
  };
}
