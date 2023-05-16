{ config, pkgs, ... }:

{
  programs.zsh.enable = true;
  users.users.kuviman.shell = pkgs.zsh;
}
