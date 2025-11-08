{ config, ... }:
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.${config.nixfiles.username}.extraGroups = [ "libvirtd" ];
}
