local M = {}

function M.load()
    vim.cmd("highlight clear")
    vim.o.termguicolors = true
    vim.g.colors_name = "my-colorscheme"

    vim.api.nvim_set_hl(0, "Normal", { fg = "#ffffff", bg = "#000000" })
    vim.api.nvim_set_hl(0, "Comment", { fg = "#7f7f7f", italic = true })
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1f1f1f" })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#3f3f3f" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#5f5f5f", bold = true })

    vim.api.nvim_set_hl(0, "Keyword", { fg = "#ff00ff", bold = true })
    vim.api.nvim_set_hl(0, "String", { fg = "#00ff00", bg = "#001f00" })

    vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ff0000" })
    vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#ff7f00" })
    vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#007fff" })

    vim.api.nvim_set_hl(0, "StatusLine", { fg = "#ffffff", bg = "#000000" })
end

return M
