{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  users.users.${config.nixfiles.username}.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.devcontainer ];
}
