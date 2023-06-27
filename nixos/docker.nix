{ ... }:

{
  virtualisation.docker.enable = true;
  users.users.kuviman.extraGroups = [ "docker" ];
}
