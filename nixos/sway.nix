{ lib, config, ... }:

{
  options.nixfiles.sway = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.nixfiles.sway.enable {
    programs.sway.enable = true;
  };
}
