return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = {
      {
        "tris203/rzls.nvim",
        config = function()
          require("rzls").setup({})
        end,
      },
    },
    opts = {
      filewatching = "roslyn",
    },
    config = function(_, opts)
      require("roslyn").setup(opts)
    end,
  },
}
