vim.g.mapleader = " "
require "onedark".load()

vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" });
vim.keymap.set("n", "<esc>",
  "<cmd> nohlsearch <cr>",
  { desc = "Clear highlights" });
vim.keymap.set("n", "<c-s>",
  "<cmd> update <cr>",
  { desc = "Save file" });
vim.keymap.set("t", "<c-n>",
  vim.api.nvim_replace_termcodes("<c-\\><c-n>", true, true, true),
  { desc = "Escape terminal mode" })

vim.opt.winblend = 10 -- https://neovide.dev/faq.html#how-to-enable-floating-and-popupmenu-transparency

vim.opt.clipboard = "unnamedplus"

-- Highlight the text line of the cursor
vim.opt.cursorline = true

-- fkc this rust formatter - i want my tabs back
local tabsize = 4
vim.opt.expandtab = true -- Expand tabs to spaces
vim.opt.shiftwidth = tabsize
vim.opt.tabstop = tabsize
vim.opt.softtabstop = tabsize
vim.opt.smartindent = true -- Auto detect indent size

vim.opt.fillchars = {
  eob = " ", -- empty lines at the end of a buffers (default is ~)
}

-- Spellchecking
vim.opt.spell = false

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
vim.opt.ruler = true
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
local telescopeConfig = require("telescope.config")
-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")
telescope.setup {
  defaults = {
    prompt_prefix = "   ",
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments,
  },
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
}
vim.keymap.set("n", "<leader>'",
  "<cmd> Telescope resume <cr>",
  { desc = "Open last picker" })
vim.keymap.set("n", "<leader>f",
  "<cmd> Telescope find_files <cr>",
  { desc = "Find files" })
vim.keymap.set("n", "<leader>D",
  "<cmd> Telescope diagnostics <cr>",
  { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>ta",
  "<cmd> Telescope <cr>",
  { desc = "Find anything" })
vim.keymap.set("n", "<leader>ts",
  "<cmd> Telescope treesitter <cr>",
  { desc = "Find treesitter symbols" })
vim.keymap.set("n", "<leader>S",
  "<cmd> Telescope lsp_workspace_symbols <cr>",
  { desc = "Find workspace symbols" })
vim.keymap.set("n", "<leader>/",
  "<cmd> Telescope live_grep <cr>",
  { desc = "Live grep" })
vim.keymap.set("n", "<leader>tb",
  "<cmd> Telescope buffers <cr>",
  { desc = "Find buffers" })
vim.keymap.set("n", "<leader>th",
  "<cmd> Telescope help_tags <cr>",
  { desc = "Help page" })
vim.keymap.set("n", "<leader>to",
  "<cmd> Telescope oldfiles <cr>",
  { desc = "Find oldfiles" })
vim.keymap.set("n", "<leader>tz",
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
      enable = true,
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
    ['<C-CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
lspconfig.html.setup {}
lspconfig.jsonls.setup {}
lspconfig.ts_ls.setup {}
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
lspconfig.nixd.setup {
  settings = {
    nixd = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
}
lspconfig.zls.setup {}
lspconfig.ocamllsp.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>d",
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
  "<cmd> Telescope lsp_definitions <cr>",
  { desc = "Go to definition" })
vim.keymap.set("n", "<leader>k",
  vim.lsp.buf.hover,
  { desc = "LSP hover" })
vim.keymap.set("n", "gi",
  vim.lsp.buf.implementation,
  { desc = "Go to implementation" })
vim.keymap.set({ "n", "i" }, "<c-k>",
  vim.lsp.buf.signature_help,
  { desc = "Signature help" })
vim.keymap.set("n", "gy",
  function()
    vim.lsp.buf.type_definition({
      on_list = function()
        vim.cmd("Telescope lsp_type_definitions")
      end
    })
  end,
  { desc = "Type definition" })
vim.keymap.set("n", "<leader>r",
  vim.lsp.buf.rename,
  { desc = "Rename" })
vim.keymap.set({ "n", "v" }, "<leader>a",
  vim.lsp.buf.code_action,
  { desc = "Code action" })
vim.keymap.set("n", "gr",
  "<cmd> Telescope lsp_references <cr>",
  { desc = "See references" })
vim.keymap.set('n', '<leader>F',
  function()
    vim.lsp.buf.format { async = true }
  end,
  { desc = "Format file" })

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
  },
  -- LSP configuration
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<Leader>a",
        function() vim.cmd.RustLsp('codeAction') end,
        { desc = "Code action groups", buffer = bufnr })
      vim.keymap.set("v", "<Leader>k",
        function() vim.cmd.RustLsp { 'hover', 'range' } end,
        { desc = "Hover range", buffer = bufnr })
    end,
    default_settings = {
      ['rust-analyzer'] = {
        cargo = {
          features = "all",
        },
        check = {
          -- targets = {
          --   "x86_64-unknown-linux-gnu",
          --   "wasm32-unknown-unknown",
          -- },
          command = "clippy",
        },
      },
    },
  },
  -- DAP configuration
  dap = {
  },
}

require("Comment").setup()
vim.keymap.set("n", "<C-c>",
  function()
    require("Comment.api").toggle.linewise.current()
  end,
  { desc = "Toggle comment" })

vim.keymap.set("v", "<C-c>",
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
      init_selection = '<m-o>',
      node_incremental = '<m-o>',
      scope_incremental = '<c-s-s>', -- this one should be mapped to smth else
      node_decremental = '<m-i>',
    },
  },
}

require "treesitter-context".setup {
  max_lines = 5,
}

-- auto-reload files when modified externally
-- https://unix.stackexchange.com/a/383044
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

require("fidget").setup {
  -- options
}

-- indent_blankline
require("ibl").setup({
  indent = { char = "▏" },
  whitespace = {
    remove_blankline_trail = false,
  },
  scope = { enabled = true },
})

-- format on save (https://www.mitchellhanberg.com/modern-format-on-save-in-neovim/)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    -- 2
    vim.api.nvim_create_autocmd("BufWritePre", {
      -- 3
      buffer = args.buf,
      callback = function()
        -- 4 + 5
        vim.lsp.buf.format { async = false, id = args.data.client_id }
      end,
    })
  end
})

require("cellular-automaton").register_animation {
  fps = 20,
  name = "glitch",
  update = function(grid)
    local choices = {}
    local isspace = function(c)
      return c == ' '
    end
    local adjacent = { { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } }
    for i = 1, #grid do
      for j = 1, #(grid[i]) do
        if not isspace(grid[i][j].char) then
          for ai = 1, #adjacent do
            local ni = i + adjacent[ai][1]
            local nj = j + adjacent[ai][2]
            local ac = grid[ni] and grid[ni][nj]
            if ac and isspace(ac.char) then
              choices[#choices + 1] = { { i, j }, { ni, nj } }
            end
          end
        end
      end
    end
    if #choices ~= 0 then
      local choice = choices[math.random(#choices)]
      local i = choice[1][1]
      local j = choice[1][2]
      local ni = choice[2][1]
      local nj = choice[2][2]
      grid[i][j], grid[ni][nj] = grid[ni][nj], grid[i][j]
    end
    return true
  end,
}
