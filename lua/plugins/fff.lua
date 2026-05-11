return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    opts = {
      prompt = "  ",
      title = "FFFiles",
      layout = {
        prompt_position = "top",
        preview_position = "right",
      },
    },
    keys = {
      { "<leader><leader>", function() require("fff").find_files() end, desc = "FFF: find files" },
      { "<leader>ff", function() require("fff").live_grep() end, desc = "FFF: live grep" },
      {
        "<leader>fz",
        function() require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } }) end,
        desc = "FFF: fuzzy grep",
      },
      {
        "<leader>fc",
        function() require("fff").live_grep({ query = vim.fn.expand("<cword>") }) end,
        desc = "FFF: grep current word",
      },
    },
  },
}
