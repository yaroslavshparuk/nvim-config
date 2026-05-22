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
      { "<leader>nr", "<cmd>Dotnet run profile default<cr>",   desc = "Dotnet: run (default, pick profile)" },
      { "<leader>nR", "<cmd>Dotnet run<cr>",                    desc = "Dotnet: run (pick)" },
      { "<leader>nP", "<cmd>Dotnet run profile<cr>",            desc = "Dotnet: run (pick profile)" },
      { "<leader>nb", "<cmd>Dotnet build default quickfix<cr>", desc = "Dotnet: build (default → quickfix)" },
      { "<leader>nB", "<cmd>Dotnet build<cr>",                  desc = "Dotnet: build (pick)" },
      { "<leader>nt", "<cmd>Dotnet terminal toggle<cr>",        desc = "Dotnet: toggle output terminal" },
      { "<leader>nT", "<cmd>Dotnet testrunner<cr>",             desc = "Dotnet: test runner" },
      { "<leader>nU", "<cmd>Dotnet test default<cr>",           desc = "Dotnet: test (default)" },
      { "<leader>nw", "<cmd>Dotnet watch default<cr>",          desc = "Dotnet: watch (default)" },
      { "<leader>nd", "<cmd>Dotnet debug<cr>",                  desc = "Dotnet: debug (DAP)" },
      { "<leader>nD", "<cmd>Dotnet debug profile<cr>",          desc = "Dotnet: debug (pick profile)" },
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
