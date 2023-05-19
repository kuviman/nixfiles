{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git curl wget zip unzip gnutar gzip # for mason
    neovide
    # Make neovim plugins that download stuff work
    (buildFHSUserEnv {
      name = "v";
      runScript = "nvim";
      targetPkgs = pkgs: [];
    })
  ];
}
