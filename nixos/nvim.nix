{ pkgs, inputs, self, system, ... }:

{
  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    self.packages.${system}.nvim
    gcc # treesitter requires
    neovide
    (inputs.self.patchDesktop pkgs neovide "neovide" "^Exec=neovide" "Exec=${neovide}/bin/neovide --frame none")
    fd
    ripgrep # yep
    nil # nix language server
  ];
}
