{ config, lib, ... }:
{
  options = {
    programs.nnn = {
      quitcd.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = {
    programs.zsh.initContent = lib.mkIf config.programs.nnn.quitcd.enable (
      builtins.readFile ./quitcd.zsh
    );
  };
}
