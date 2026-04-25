{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        # wlrobs
        droidcam-obs
        input-overlay
        # obs-backgroundremoval
        obs-vkcapture
        obs-3d-effect
        obs-shaderfilter
        obs-pipewire-audio-capture
        obs-source-record
        input-overlay
        obs-multi-rtmp
      ];
    })
  ];
}
