{ pkgs, lib, ... }:

let
  finalPackage = pkgs.wayfire-with-plugins.override {
    wayfire = pkgs.wayfire;
    plugins = with pkgs.wayfirePlugins; [
      wcm
      wf-shell
      wayfire-plugins-extra
    ];
  };
  sessionPackage = (pkgs.writeTextDir "share/wayland-sessions/wayfire.desktop"
    ''
      [Desktop Entry]
      Name=Wayfire
      Comment=Wayfire
      Exec=env XDG_CURRENT_DESKTOP=Wayfire ${finalPackage}/bin/wayfire
      Type=Application
    '').overrideAttrs {
    passthru.providedSessions = [ "wayfire" ];
  };
  portalsPackage = (pkgs.writeTextDir "share/xdg-desktop-portal/wayfire-portals.conf"
    ''
      [preferred]
      default=wlr
    '');
in
{
  # TODO should instead be this but doesnt show in gdm
  # programs.wayfire.enable = true;
  # programs.wayfire.plugins = with pkgs.wayfirePlugins; [
  #   wcm
  #   wf-shell
  #   wayfire-plugins-extra
  # ];

  environment.systemPackages = [
    finalPackage
    portalsPackage
  ];
  services.xserver.displayManager.sessionPackages = [
    sessionPackage
  ];
  xdg.portal = {
    enable = lib.mkDefault true;
    wlr.enable = lib.mkDefault true;
  };
}
