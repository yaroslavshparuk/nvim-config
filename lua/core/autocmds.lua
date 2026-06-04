local group = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.highlight.on_yank({ timeout = 200 })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*",
    callback = function()
        local save = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.winrestview(save)
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Highlight the current line only in the focused window. Recompute across all
-- windows (rather than a fragile per-window on/off) so the highlight survives
-- splits/terminals being opened and closed under us — e.g. easy-dotnet's
-- managed terminal panel, after which a WinEnter to restore it may not fire.
local function refresh_cursorline()
    local cur = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_is_valid(win) then
            vim.wo[win].cursorline = (win == cur)
        end
    end
end

vim.api.nvim_create_autocmd(
    { "WinEnter", "BufWinEnter", "WinClosed", "TermClose", "TermLeave" },
    {
        group = group,
        callback = function()
            vim.schedule(refresh_cursorline)
        end,
    }
)

vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#7c7f93", bg = "NONE" })
    end,
})

vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#7c7f93", bg = "NONE" })
