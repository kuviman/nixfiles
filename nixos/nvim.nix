{ pkgs, pkgs-unstable, inputs, self, system, ... }:

let neovide = pkgs-unstable.neovide;
in
{
  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    self.packages.${system}.nvim
    gcc # treesitter requires
    neovide
    (inputs.self.lib.patchDesktop pkgs neovide "neovide" "^Exec=neovide" "Exec=${neovide}/bin/neovide --frame none")
    fd
    ripgrep # yep
    nil # nix language server
  ];
}
