return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = { enabled = true },
        which_key = true,
        mason = true,
        mini = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")

      local palette = require("catppuccin.palettes").get_palette("mocha")
      local set = vim.api.nvim_set_hl
      set(0, "NvimTreeFolderName",        { fg = palette.blue,  bold = true })
      set(0, "NvimTreeOpenedFolderName",  { fg = palette.sapphire, bold = true, italic = true })
      set(0, "NvimTreeEmptyFolderName",   { fg = palette.overlay1 })
      set(0, "NvimTreeFolderIcon",        { fg = palette.yellow })
      set(0, "NvimTreeRootFolder",        { fg = palette.mauve, bold = true })
      set(0, "NvimTreeSymlink",           { fg = palette.teal,  italic = true })
      set(0, "NvimTreeExecFile",          { fg = palette.green, bold = true })
      set(0, "NvimTreeSpecialFile",       { fg = palette.peach, underline = true })
      set(0, "NvimTreeOpenedFile",        { fg = palette.text,  bold = true })
      set(0, "NvimTreeModifiedFile",      { fg = palette.peach })
      set(0, "NvimTreeNormalFile",        { fg = palette.text })
      set(0, "NvimTreeGitNew",            { fg = palette.green })
      set(0, "NvimTreeGitDirty",          { fg = palette.yellow })
      set(0, "NvimTreeGitStaged",         { fg = palette.sky })
      set(0, "NvimTreeGitDeleted",        { fg = palette.red })
      set(0, "NvimTreeGitIgnored",        { fg = palette.overlay0 })
    end,
  },
}
