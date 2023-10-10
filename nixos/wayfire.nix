{ pkgs, ... }: {
  programs.wayfire.enable = true;
  programs.wayfire.plugins = with pkgs.wayfirePlugins; [
    wcm
    wf-shell
    wayfire-plugins-extra
  ];
}
