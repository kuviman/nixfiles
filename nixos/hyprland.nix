{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      hyprland = inputs.hyprland.packages.${self.system}.hyprland;
    })
  ];
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };
  environment.systemPackages = with pkgs; [
    waybar
    hyprpaper
    hyprpicker
    hyprshot
    mako # notifications
    wofi
    pavucontrol
  ];
}
