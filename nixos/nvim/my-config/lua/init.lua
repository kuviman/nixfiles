vim.g.mapleader = " "
require "onedark".load()

vim.keymap.set("n", "<esc>",
  "<cmd> nohlsearch <cr>",
  { desc = "Clear highlights" });
vim.keymap.set("n", "<c-s>",
  "<cmd> update <cr>",
  { desc = "Save file" });
vim.keymap.set("t", "<c-n>",
  vim.api.nvim_replace_termcodes("<c-\\><c-n>", true, true, true),
  { desc = "Escape terminal mode" })

vim.opt.guifont = { "JetBrainsMono Nerd Font", ":h16" }

vim.opt.clipboard = "unnamedplus"

-- Highlight the text line of the cursor
vim.opt.cursorline = true

local tabsize = 2
vim.opt.expandtab = true -- Expand tabs to spaces
vim.opt.shiftwidth = tabsize
vim.opt.tabstop = tabsize
vim.opt.softtabstop = tabsize
vim.opt.smartindent = true -- Auto detect indent size

vim.opt.fillchars = {
  eob = " ", -- empty lines at the end of a buffers (default is ~)
}

-- Search
vim.opt.ignorecase = true    -- Ignore case in search patterns
vim.opt.smartcase = true     -- Don't ignore case if there is uppercase chars
vim.opt.shortmess:append "s" -- disable "search hit BOTTOM" & similar

-- Disable mouse
vim.opt.mouse = ""

-- Numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.ruler = false
vim.opt.scrolloff = 10 -- Min number of lines around the cursor

-- Disable nvim intro
vim.opt.shortmess:append "I"

-- Always draw sign column
vim.opt.signcolumn = "yes"

-- Enable 24-bit rgb
vim.opt.termguicolors = true

-- Time to wait for mapped sequence to complete
vim.opt.timeoutlen = 400

-- Save undo history
vim.opt.undofile = true

-- Interval for writing swap file to disk, also used by gitsigns
vim.opt.updatetime = 250

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- dont list quickfix buffers
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

local hop = require "hop"
hop.setup()
vim.keymap.set("n", "<leader>ha",
  function()
    hop.hint_anywhere()
  end,
  { desc = "Hop anywhere" })
vim.keymap.set("n", "<leader>hf",
  function()
    hop.hint_char1()
  end,
  { desc = "Hop char 1" })
vim.keymap.set("n", "<leader>hb",
  function()
    hop.hint_char2()
  end,
  { desc = "Hop char 2" })
vim.keymap.set("n", "<leader>hw",
  function()
    hop.hint_words()
  end,
  { desc = "Hop words" })
vim.keymap.set("n", "<leader>hl",
  function()
    hop.hint_lines()
  end,
  { desc = "Hop lines" })

local trouble = require "trouble"
trouble.setup()
vim.keymap.set("n", "<leader>tt",
  function()
    trouble.toggle()
  end,
  { desc = "Toggle trouble" })

require("which-key").setup()
vim.keymap.set("n", "<leader>wk",
  "<cmd> WhichKey <cr>",
  { desc = "Which key" })

local telescope = require "telescope"
telescope.setup {
  defaults = {
    prompt_prefix = "   ",
  },
}
vim.keymap.set("n", "<leader>ff",
  "<cmd> Telescope find_files <cr>",
  { desc = "Find files" })
vim.keymap.set("n", "<leader>fa",
  "<cmd> Telescope <cr>",
  { desc = "Find anything" })
vim.keymap.set("n", "<leader>fw",
  "<cmd> Telescope live_grep <cr>",
  { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb",
  "<cmd> Telescope buffers <cr>",
  { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh",
  "<cmd> Telescope help_tags <cr>",
  { desc = "Help page" })
vim.keymap.set("n", "<leader>fo",
  "<cmd> Telescope oldfiles <cr>",
  { desc = "Find oldfiles" })
vim.keymap.set("n", "<leader>fz",
  "<cmd> Telescope current_buffer_fuzzy_find <cr>",
  { desc = "Find in current buffer" })
vim.keymap.set("n", "<leader>cm",
  "<cmd> Telescope git_commits <cr>",
  { desc = "Git commits" })
vim.keymap.set("n", "<leader>gt",
  "<cmd> Telescope git_status <cr>",
  { desc = "Git status" })

local nvim_tree = require "nvim-tree"
nvim_tree.setup {
  filters = {
    dotfiles = false,
  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    adaptive_size = false,
    width = 30,
    preserve_window_proportions = true,
  },
  git = {
    enable = true,
    ignore = true,
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    root_folder_label = false,
    highlight_git = true,
    highlight_opened_files = "none",

    indent_markers = {
      enable = false,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      },

      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
}
vim.g.nvimtree_side = "right"
vim.keymap.set("n", "<leader>e",
  "<cmd> NvimTreeFocus <cr>",
  { desc = "Focus nvim tree" })
vim.keymap.set("n", "<c-n>",
  "<cmd> NvimTreeToggle <cr>",
  { desc = "Toggle nvim tree" })

-- Set up nvim-cmp.
local cmp = require "cmp"
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require "luasnip".lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup language servers.
local lspconfig = require "lspconfig"
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>fd",
  vim.diagnostic.open_float,
  { desc = "Float diagnostic" })
vim.keymap.set("n", "<leader>[",
  vim.diagnostic.goto_prev,
  { desc = "Prev diagnostic" })
vim.keymap.set("n", "<leader>]",
  vim.diagnostic.goto_next,
  { desc = "Next diagnostic" })
vim.keymap.set("n", "gD",
  vim.lsp.buf.declaration,
  { desc = "Go to declaration" })
vim.keymap.set("n", "gd",
  vim.lsp.buf.definition,
  { desc = "Go to definition" })
vim.keymap.set("n", "K",
  vim.lsp.buf.hover,
  { desc = "LSP hover" })
vim.keymap.set("n", "gi",
  vim.lsp.buf.implementation,
  { desc = "Go to implementation" })
vim.keymap.set({ "n", "i" }, "<c-k>",
  vim.lsp.buf.signature_help,
  { desc = "Signature help" })
vim.keymap.set("n", "<space>D",
  function()
    vim.lsp.buf.type_definition({
      on_list = function()
        vim.cmd("Telescope lsp_type_definitions")
      end
    })
  end,
  { desc = "Type definition" })
vim.keymap.set("n", "<space>rn",
  vim.lsp.buf.rename,
  { desc = "Rename" })
vim.keymap.set({ "n", "v" }, "<space>ca",
  vim.lsp.buf.code_action,
  { desc = "Code action" })
vim.keymap.set("n", "gr",
  "<cmd> Telescope lsp_references <cr>",
  { desc = "See references" })
vim.keymap.set('n', '<space>fm',
  function()
    vim.lsp.buf.format { async = true }
  end,
  { desc = "Format file" })

local rust_tools = require("rust-tools")
rust_tools.setup({
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<C-space>",
        rust_tools.hover_actions.hover_actions,
        { desc = "Hover actions", buffer = bufnr })
      vim.keymap.set("n", "<Leader>a",
        rust_tools.code_action_group.code_action_group,
        { desc = "Code action groups", buffer = bufnr })
    end,
    check = {
      targets = {
        "x86_64-unknown-linux-gnu",
        "wasm32-unknown-unknown",
      },
    },
  },
})

require("Comment").setup()
vim.keymap.set("n", "<leader>/",
  function()
    require("Comment.api").toggle.linewise.current()
  end,
  { desc = "Toggle comment" })

vim.keymap.set("v", "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "Toggle comment" })

require("nvim-surround").setup()

require("toggleterm").setup {
  open_mapping = [[<c-\>]],
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  direction = "float",
}

require "nvim-treesitter.configs".setup {
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s-s>',
      node_decremental = '<m-space>',
    },
  },
}
