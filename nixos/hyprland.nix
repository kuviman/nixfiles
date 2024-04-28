{ pkgs, inputs, ... }:

{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };
  environment.systemPackages = with pkgs; [
    waybar
    hyprpaper
    hyprpicker
    wofi
  ];
}
