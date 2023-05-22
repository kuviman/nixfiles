{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    gcc # treesitter requires
    neovide
    fd
    ripgrep # yep

    rust-analyzer
    nil # nix language server
  ];
}
