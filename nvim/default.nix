{ pkgs, ... }:

let
  singleLuaPlugin = { path, main ? false }:
    let
      name = pkgs.lib.removeSuffix ".lua" (baseNameOf path);
    in
    pkgs.vimUtils.buildVimPlugin {
      inherit name;
      src = pkgs.runCommand (name + "-src") { } (
        if main then ''
          mkdir -p $out/lua
          cp ${path} $out/lua/init.lua
        '' else ''
          mkdir -p $out/lua
          cp ${path} $out/lua/${name}.lua
        ''
      );
      doCheck = false;
    };
in
pkgs.wrapNeovim pkgs.neovim-unwrapped {
  configure = {
    customRC = ''
      lua require("init")
    '';
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [
        (singleLuaPlugin { path = ./my-colorscheme.lua; })
        (singleLuaPlugin { path = ./my-config.lua; main = true; })
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
        haskell-tools-nvim
        dressing-nvim
        cellular-automaton-nvim
      ];
      opt = [
        vim-visual-multi
      ];
    };
  };
}
