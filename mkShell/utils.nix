{ pkgs, config, lib, ... }:

{
  options.utils = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
  config = lib.mkIf config.utils.enable {
    packages = with pkgs; [
      git
      lazygit
      eza
      bat
      curl
      wget
      neofetch
      tokei
      ripgrep
      fd
      bottom
      nnn
      zellij
      helix
      dua

      pyright
      # python313Packages.autopep8
      (python3.withPackages (p: [ p.pyyaml p.autopep8 ]))
    ];
  };
}
