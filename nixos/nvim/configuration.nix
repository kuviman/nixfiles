{ pkgs, inputs, ... }:

{
  programs.neovim = {
    enable = true;
    configure = {
      customRC = ''
        lua require("init")
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          (pkgs.vimUtils.buildVimPlugin {
            name = "my-config";
            src = ./my-config;
          })
          onedark-nvim
          vim-fugitive
          lazygit-nvim
          auto-session
          hop-nvim
          trouble-nvim
          direnv-vim
          nvim-treesitter
          nvim-treesitter-context
          gitsigns-nvim
          nvim-web-devicons
          indent-blankline-nvim
          nvim-colorizer-lua
          nvim-lspconfig
          nvim-cmp
          nvim-autopairs
          luasnip
          cmp_luasnip
          cmp-nvim-lua
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          comment-nvim
          nvim-tree-lua
          telescope-nvim
          which-key-nvim
        ];
        opt = [
          vim-visual-multi
        ];
      };
    };
  };
  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    gcc # treesitter requires
    neovide
    (inputs.self.patchDesktop pkgs neovide "neovide" "^Exec=neovide" "Exec=env WINIT_UNIX_BACKEND=x11 neovide --multigrid")
    fd
    ripgrep # yep

    rust-analyzer
    nil # nix language server
  ];
}
