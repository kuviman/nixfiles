{ lib, ... }:
lib.mkDefault {
  nixfiles = {
    username = "kuviman";
    second_username = "mikky_ti";
    hyprland.enable = true;
    gnome.enable = true;
  };
}
