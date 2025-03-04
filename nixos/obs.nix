{ pkgs-stable, ... }:

{
  environment.systemPackages = with pkgs-stable; [
    (wrapOBS {
      plugins = with obs-studio-plugins; [
        # wlrobs
        # droidcam-obs
        input-overlay
        # obs-backgroundremoval
        obs-vkcapture
        obs-3d-effect
        obs-shaderfilter
        obs-pipewire-audio-capture
        input-overlay
        obs-multi-rtmp
      ];
    })
  ];
}
