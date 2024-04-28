{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.systemPackages = with pkgs; [
    waybar
    hyprpaper
    hyprpicker
    wofi
  ];
}
