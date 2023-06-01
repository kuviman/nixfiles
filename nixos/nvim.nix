{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    gcc # treesitter requires
    neovide
    (inputs.self.patchDesktop pkgs neovide "neovide" "^Exec=neovide" "Exec=env WINIT_UNIX_BACKEND=x11 neovide --multigrid")
    fd
    ripgrep # yep

    rust-analyzer
    nil # nix language server
  ];
}
