{ config, lib, pkgs, ... }:
{
  options.neovim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.neovim.enable {
    packages = [ (import ../nvim { inherit pkgs; }) ];
  };
}
