{ config, lib, pkgs, ... }:
{
  options.neovim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  options.lua = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = {
    packages = [
      (lib.mkIf config.neovim.enable (import ../nvim { inherit pkgs; }))
      (lib.mkIf config.lua.enable pkgs.lua-language-server)
    ];
  };
}
