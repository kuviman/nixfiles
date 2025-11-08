{ lib, config, ... }:
{
  options.nixfiles.minecraft-server = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.nixfiles.minecraft-server.enable {
    services.minecraft-server = {
      enable = true;
      eula = true;
    };
  };
}
