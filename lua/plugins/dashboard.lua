return {
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            local headers = {
                {
                    [[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
                    [[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
                    [[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
                    [[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
                    [[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
                    [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
                },
                {
                    [[    _   __                _              ]],
                    [[   / | / /__  ____ _   __(_)___ ___      ]],
                    [[  /  |/ / _ \/ __ \ | / / / __ `__ \     ]],
                    [[ / /|  /  __/ /_/ / |/ / / / / / / /     ]],
                    [[/_/ |_/\___/\____/|___/_/_/ /_/ /_/      ]],
                },
                {
                    [[ ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓]],
                    [[ ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒]],
                    [[▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░]],
                    [[▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ]],
                    [[▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒]],
                    [[░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░]],
                },
                {
                    [[ _   _  _______  _____  _    _ _____ _______ ]],
                    [[ |\  |  |______ |     |  \  /    |   |  |  | ]],
                    [[ | \_|  |______ |_____|   \/   __|__ |  |  | ]],
                },
            }

            local quotes = {
                "“Programs must be written for people to read.” — H. Abelson",
                "“Make it work, make it right, make it fast.” — Kent Beck",
                "“Premature optimisation is the root of all evil.” — D. Knuth",
                "“Talk is cheap. Show me the code.” — Linus Torvalds",
                "“Simplicity is the soul of efficiency.” — Austin Freeman",
                "“First, solve the problem. Then, write the code.” — J. Johnson",
                "“Code is like humour. When you have to explain it, it’s bad.” — C. House",
                "“The best error message is the one that never shows up.” — T. Sundell",
                "“We’ve always done it this way is the most damaging phrase.” — G. Hopper",
                "“Any fool can write code a computer can understand.” — M. Fowler",
            }

            math.randomseed(os.time())
            dashboard.section.header.val = headers[1]

            local quote = {
                type = "text",
                val = quotes[math.random(#quotes)],
                opts = { position = "center", hl = "AlphaQuote" },
            }

            dashboard.section.buttons.val = {}

            dashboard.section.footer.val = function()
                local stats = require("lazy").stats()
                local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
                return { "  " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. "ms" }
            end

            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.footer.opts.hl = "AlphaFooter"

            dashboard.opts.layout = {
                { type = "padding", val = 4 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                quote,
                { type = "padding", val = 2 },
                dashboard.section.footer,
            }

            alpha.setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    local prev_laststatus = vim.opt.laststatus:get()
                    local prev_showtabline = vim.opt.showtabline:get()
                    vim.opt.laststatus = 0
                    vim.opt.showtabline = 0
                    vim.api.nvim_create_autocmd("BufUnload", {
                        buffer = 0,
                        callback = function()
                            vim.opt.laststatus = prev_laststatus
                            vim.opt.showtabline = prev_showtabline
                        end,
                    })
                end,
            })
        end,
    },
}
