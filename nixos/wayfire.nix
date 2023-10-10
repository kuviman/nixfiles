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
      Exec=${finalPackage}/bin/wayfire
      Type=Application
    '').overrideAttrs {
    passthru.providedSessions = [ "wayfire" ];
  };
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
  ];
  services.xserver.displayManager.sessionPackages = [
    sessionPackage
  ];
  xdg.portal = {
    enable = lib.mkDefault true;
    wlr.enable = lib.mkDefault true;
  };
}
