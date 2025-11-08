{ pkgs, lib, config, ... }:

{
  options.nixfiles.hyprland = {
    enable = lib.mkOption
      {
        type = lib.types.bool;
        default = false;
      };
  };
  config = lib.mkIf config.nixfiles.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    xdg.portal.wlr.enable = lib.mkForce true; # Or conflict with sway
    environment.systemPackages = with pkgs; [
      hyprpanel
      hyprpaper
      hyprpicker
      hyprshot
      wofi
      pavucontrol
    ];
  };
}
