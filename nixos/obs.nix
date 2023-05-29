{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      obs-studio = prev.obs-studio.overrideAttrs (oldAttrs: {
        preFixup = ''
          qtWrapperArgs+=(
            --prefix LD_LIBRARY_PATH : "${with final; lib.makeLibraryPath [ xorg.libX11 libvlc libGL ]}"
            ''${gappsWrapperArgs[@]}
          )
        '';
      });
    })
  ];
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
