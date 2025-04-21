{ pkgs, lib, config, ... }:

{
  options.nix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.nix.enable {
    packages = with pkgs; [ nixd nixpkgs-fmt ];
  };
}
