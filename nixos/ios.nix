{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    uxplay
  ];
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      userServices = true;
      domain = true;
    };
  };
  networking.firewall.enable = false;
}
