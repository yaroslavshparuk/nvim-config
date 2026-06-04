-- easy-dotnet opens its managed terminal panel and steals focus into it (in
-- insert mode). For long-running apps (e.g. Aspire AppHost) the panel never
-- auto-hides, so focus stays trapped in the terminal. Wrap the launch commands
-- so focus returns to the window we launched from once the panel appears, while
-- leaving the panel open to watch the output.
local function run_keep_focus(cmd)
  return function()
    local src_win = vim.api.nvim_get_current_win()
    local grp = vim.api.nvim_create_augroup("EasyDotnetReturnFocus", { clear = true })
    vim.api.nvim_create_autocmd("TermOpen", {
      group = grp,
      callback = function()
        vim.schedule(function()
          if vim.api.nvim_win_is_valid(src_win) then
            pcall(vim.api.nvim_set_current_win, src_win)
            vim.cmd("stopinsert")
          end
        end)
        pcall(vim.api.nvim_del_augroup_by_id, grp)
      end,
    })
    -- Disarm if no terminal ever opens (e.g. a cancelled picker or build error).
    vim.defer_fn(function() pcall(vim.api.nvim_del_augroup_by_id, grp) end, 30000)
    vim.cmd(cmd)
  end
end

return {
  {
    "GustavEikaas/easy-dotnet.nvim",
    ft = { "cs", "fsharp" },
    cmd = { "Dotnet" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      picker = "telescope",
      auto_bootstrap_namespace = { enabled = true, type = "block_scoped" },
      test_runner = {
        viewmode = "float",
        auto_start = true,
      },
      debugger = {
        auto_register_dap = true,
        console = "integratedTerminal",
      },
      lsp = {
        enabled = true,
        preload_roslyn = true,
        roslynator_enabled = true,
        easy_dotnet_analyzer_enabled = true,
        auto_refresh_codelens = true,
      },
      managed_terminal = { auto_hide = true },
    },
    keys = {
      { "<leader>nr", run_keep_focus("Dotnet run profile default"), desc = "Dotnet: run (default, pick profile)" },
      { "<leader>nR", run_keep_focus("Dotnet run"),                 desc = "Dotnet: run (pick)" },
      { "<leader>nP", run_keep_focus("Dotnet run profile"),         desc = "Dotnet: run (pick profile)" },
      { "<leader>nb", "<cmd>Dotnet build default quickfix<cr>", desc = "Dotnet: build (default → quickfix)" },
      { "<leader>nB", "<cmd>Dotnet build<cr>",                  desc = "Dotnet: build (pick)" },
      { "<leader>nt", "<cmd>Dotnet terminal toggle<cr>",        desc = "Dotnet: toggle output terminal" },
      { "<leader>nT", "<cmd>Dotnet testrunner<cr>",             desc = "Dotnet: test runner" },
      { "<leader>nU", "<cmd>Dotnet test default<cr>",           desc = "Dotnet: test (default)" },
      { "<leader>nw", run_keep_focus("Dotnet watch default"),       desc = "Dotnet: watch (default)" },
      { "<leader>nd", run_keep_focus("Dotnet debug"),               desc = "Dotnet: debug (DAP)" },
      { "<leader>nD", run_keep_focus("Dotnet debug profile"),       desc = "Dotnet: debug (pick profile)" },
      { "<leader>na", "<cmd>Dotnet debug attach<cr>",           desc = "Dotnet: debug attach" },
      { "<leader>ns", "<cmd>Dotnet secrets<cr>",                desc = "Dotnet: user secrets" },
      { "<leader>nn", "<cmd>Dotnet new<cr>",                    desc = "Dotnet: new project" },
      { "<leader>np", "<cmd>Dotnet add package<cr>",            desc = "Dotnet: add NuGet package" },
      { "<leader>no", "<cmd>Dotnet outdated<cr>",               desc = "Dotnet: outdated packages" },
      { "<leader>nv", "<cmd>Dotnet project view<cr>",           desc = "Dotnet: project view" },
      { "<leader>ne", "<cmd>Dotnet ef database update<cr>",     desc = "Dotnet: EF database update" },
      { "<leader>nS", "<cmd>Dotnet solution select<cr>",        desc = "Dotnet: select solution" },
      { "<leader>nx", "<cmd>Dotnet reset<cr>",                  desc = "Dotnet: reset cached state" },
    },
    config = function(_, opts)
      require("easy-dotnet").setup(opts)
    end,
  },
}
