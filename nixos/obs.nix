{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        droidcam-obs
        input-overlay
        obs-backgroundremoval
        obs-vkcapture
      ];
    })
  ];
}
