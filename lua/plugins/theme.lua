return {
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = false,
    priority = 1000,
    opts = {
      contrast = "soft",
      transparent_mode = true,
      terminal_colors = true,
      bold = true,
      italic = {
        strings = false,
        comments = true,
        folds = true,
      },
      overrides = {
        ["@function"]             = { link = "GruvboxAqua" },
        ["@function.call"]        = { link = "GruvboxAqua" },
        ["@function.method"]      = { link = "GruvboxAqua" },
        ["@function.method.call"] = { link = "GruvboxAqua" },
        ["@function.builtin"]     = { link = "GruvboxAqua" },
        Function                  = { link = "GruvboxAqua" },
      },
    },
    config = function(_, opts)
      vim.o.background = "dark"
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")

      local p = require("gruvbox").palette
      local set = vim.api.nvim_set_hl
      set(0, "NvimTreeFolderName",        { fg = p.bright_blue,   bold = true })
      set(0, "NvimTreeOpenedFolderName",  { fg = p.bright_aqua,   bold = true, italic = true })
      set(0, "NvimTreeEmptyFolderName",   { fg = p.gray })
      set(0, "NvimTreeFolderIcon",        { fg = p.bright_yellow })
      set(0, "NvimTreeRootFolder",        { fg = p.bright_purple, bold = true })
      set(0, "NvimTreeSymlink",           { fg = p.neutral_aqua,  italic = true })
      set(0, "NvimTreeExecFile",          { fg = p.bright_green,  bold = true })
      set(0, "NvimTreeSpecialFile",       { fg = p.bright_orange, underline = true })
      set(0, "NvimTreeOpenedFile",        { fg = p.light1,        bold = true })
      set(0, "NvimTreeModifiedFile",      { fg = p.bright_orange })
      set(0, "NvimTreeNormalFile",        { fg = p.light1 })
      set(0, "NvimTreeGitNew",            { fg = p.bright_green })
      set(0, "NvimTreeGitDirty",          { fg = p.bright_yellow })
      set(0, "NvimTreeGitStaged",         { fg = p.bright_blue })
      set(0, "NvimTreeGitDeleted",        { fg = p.bright_red })
      set(0, "NvimTreeGitIgnored",        { fg = p.gray })
    end,
  },
}
