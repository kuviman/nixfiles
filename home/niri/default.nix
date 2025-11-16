{ inputs, pkgs-unstable, ... }:
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];
  programs.dankMaterialShell = {
    enable = false;
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
