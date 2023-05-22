{ config, pkgs, ... }:

{
  programs.zsh.enable = true;
  users.users.kuviman.shell = pkgs.zsh;
  environment.pathsToLink = [
    "/share/zsh" # For completions of system packages
  ];
}
