{ pkgs, lib, config, ... }:

{
  options.nixfiles.niri = {
    enable = lib.mkOption
      {
        type = lib.types.bool;
        default = false;
      };
  };
  config = lib.mkIf config.nixfiles.niri.enable {
    programs.niri = {
      enable = true;
    };
    environment.systemPackages = with pkgs; [
      alacritty
      fuzzel
      pavucontrol
      xwayland-satellite
    ];
  };
}
