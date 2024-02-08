{ pkgs, config, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      obs-studio = config.nur.repos.materus.obs-amf;
    })
  ];
  environment.systemPackages = with pkgs; [
    (wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        # wlrobs
        droidcam-obs
        input-overlay
        # obs-backgroundremoval
        obs-vkcapture
        obs-3d-effect
        obs-shaderfilter
        obs-pipewire-audio-capture
        input-overlay
      ];
    })
  ];
}
