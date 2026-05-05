return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = { "ToggleTerm", "ToggleTermToggleAll", "TermExec" },
        keys = {
            { [[<C-\>]],    "<cmd>ToggleTerm<CR>",                      mode = { "n", "t" },         desc = "Toggle terminal" },
            { "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Toggle terminal" },
            { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>",      desc = "Float terminal" },
            { "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", desc = "Horizontal terminal" },
            { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>",   desc = "Vertical terminal" },
        },
        opts = {
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return math.floor(vim.o.columns * 0.4)
                end
            end,
            open_mapping = [[<C-\>]],
            shade_terminals = true,
            start_in_insert = true,
            persist_size = true,
            persist_mode = true,
            direction = "float",
            close_on_exit = true,
            float_opts = {
                border = "curved",
                width = function() return math.floor(vim.o.columns * 0.8) end,
                height = function() return math.floor(vim.o.lines * 0.75) end,
                winblend = 0,
            },
            highlights = {
                FloatBorder = { link = "FloatBorder" },
                NormalFloat = { link = "NormalFloat" },
            },
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)

            vim.api.nvim_create_autocmd("TermOpen", {
                pattern = "term://*toggleterm#*",
                callback = function()
                    local o = { buffer = 0 }
                    vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], o)
                    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], o)
                    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], o)
                    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], o)
                    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], o)
                end,
            })
        end,
    },
}
