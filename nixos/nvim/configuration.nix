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
          vim-abolish
          onedark-nvim
          vim-fugitive
          lazygit-nvim
          toggleterm-nvim
          auto-session
          hop-nvim
          trouble-nvim
          direnv-vim
          gitsigns-nvim
          nvim-web-devicons
          indent-blankline-nvim
          nvim-colorizer-lua
          nvim-lspconfig
          fidget-nvim
          nvim-cmp
          nvim-autopairs
          luasnip
          cmp_luasnip
          cmp-nvim-lua
          cmp-nvim-lsp
          cmp-buffer
          cmp-path
          cmp-cmdline
          comment-nvim
          nvim-tree-lua
          telescope-nvim
          which-key-nvim
          rustaceanvim
          nvim-surround
          nvim-treesitter.withAllGrammars
          nvim-treesitter-context
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
    (inputs.self.patchDesktop pkgs neovide "neovide" "^Exec=neovide" "Exec=${neovide}/bin/neovide --frame none")
    fd
    ripgrep # yep
    nil # nix language server
  ];
}
