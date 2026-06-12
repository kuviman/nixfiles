local M = {}

function M.load()
    vim.cmd("highlight clear")
    vim.o.termguicolors = true
    vim.g.colors_name = "my-colorscheme"

    function set_color(mode, colors)
        vim.api.nvim_set_hl(0, mode, colors)
    end

    set_color("Normal", { fg = "#ffffff", bg = "#000000" })
    set_color("Comment", { fg = "#7f7f7f", italic = true })
    set_color("CursorLine", { bg = "#1f1f1f" })
    set_color("LineNr", { fg = "#3f3f3f" })
    set_color("CursorLineNr", { fg = "#5f5f5f", bold = true })

    set_color("Keyword", { fg = "#ff00ff", bold = true })
    set_color("String", { fg = "#00ff00", bg = "#001f00" })

    set_color("DiagnosticError", { fg = "#ff0000" })
    set_color("DiagnosticWarn", { fg = "#ff7f00" })
    set_color("DiagnosticInfo", { fg = "#007fff" })

    set_color("StatusLine", { fg = "#ffffff", bg = "#000000" })
end

return M
