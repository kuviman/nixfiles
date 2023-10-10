{ pkgs, ... }: {
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    wofi
    waybar
    hyprpaper
    hyprpicker
  ];
}
