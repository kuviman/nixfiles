{ config, ... }:
{
  virtualisation.lxc.enable = true;
  virtualisation.lxc.lxcfs.enable = true;
  virtualisation.lxd.enable = true;
  users.users.${config.nixfiles.username}.extraGroups = [ "lxd" ];
}
