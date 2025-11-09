{ config, pkgs, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.${config.nixfiles.username}.extraGroups = [ "libvirtd" ];
  environment.systemPackages = with pkgs;[
    virt-viewer
    cdrkit
  ];
}
