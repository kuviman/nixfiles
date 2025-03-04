{ pkgs, lib, config, ... }:

{
  options = {
    kde.enable = lib.mkOption
      {
        type = lib.types.bool;
        default = false;
      };
  };
  config = lib.mkIf config.kde.enable {
    services.xserver.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # https://github.com/NixOS/nixpkgs/issues/75867
    programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
    environment.systemPackages = with pkgs; [
      libsForQt5.polonium
    ];
  };
}
