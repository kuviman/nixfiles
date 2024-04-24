{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
  ];
  services.xserver.desktopManager.gnome.enable = true;
}
