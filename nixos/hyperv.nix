{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "sd_mod" "sr_mod" ];
  virtualisation.hypervGuest = {
    enable = true;
    videoMode = "1920x1080";
  };

  services.xserver = { modules = [ pkgs.xorg.xf86videofbdev ]; videoDrivers = [ "hyperv_fb" ]; };
  users.users.gdm = { extraGroups = [ "video" ]; };
  users.users.kuviman = { extraGroups = [ "video" ]; };
}
