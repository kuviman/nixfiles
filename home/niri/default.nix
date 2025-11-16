{ inputs, pkgs-unstable, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];
  programs.niri = {
    package = pkgs-unstable.niri;
    settings = {
      input.mouse = {
        accel-speed = -0.2;
        accel-profile = "flat";
      };
      outputs = {
        "DP-2".position = { x = 0; y = 0; };
        "HDMI-A-1".position = {
          x = 2560;
          y = 180;
        };
      };
    };
  };
  programs.dankMaterialShell = {
    enable = true;
    niri = {
      enableKeybinds = true;
      enableSpawn = true;
    };
    default.settings = {
      theme = "dark";
      dynamicTheming = true;
      # Add any other settings here
    };
    default.session = {
      # Session state defaults
    };
    quickshell.package = pkgs-unstable.quickshell;
  };
}
