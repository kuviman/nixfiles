{ pkgs, ... }:

{
  virtualisation.docker.enable = true;
  users.users.kuviman.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.devcontainer ];
}
