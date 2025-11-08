{ config, pkgs, ... }:

{
  programs.zsh.enable = true;
  users.users.${config.nixfiles.username}.shell = pkgs.zsh;
  environment.pathsToLink = [
    "/share/zsh" # For completions of system packages
  ];
}
