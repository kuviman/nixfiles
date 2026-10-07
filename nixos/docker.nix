{ config, pkgs, ... }:

{
  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;
  users.users.${config.nixfiles.username}.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.devcontainer ];
}
