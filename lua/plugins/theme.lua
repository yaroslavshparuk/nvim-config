-- Muted versions of gruvbox's bright red/orange/yellow (borrowed from
-- gruvbox-material) to soften keyword/type contrast.
local muted = {
  red    = "#ea6962",
  orange = "#e78a4e",
  yellow = "#d8a657", -- kept for warnings and NvimTree only; syntax yellow is replaced by blue
  blue   = "#83a598",
  beige  = "#d4be98", -- strings: near-foreground warm beige instead of gruvbox's chartreuse green
}

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
      palette_overrides = {
        bright_red    = muted.red,
        bright_orange = muted.orange,
        -- No yellow in syntax at all: everything that was yellow (types,
        -- namespaces, semantic-token identifiers) becomes gruvbox blue.
        bright_yellow = muted.blue,
      },
      overrides = {
        ["@function"]             = { link = "GruvboxAqua" },
        ["@function.call"]        = { link = "GruvboxAqua" },
        ["@function.method"]      = { link = "GruvboxAqua" },
        ["@function.method.call"] = { link = "GruvboxAqua" },
        ["@function.builtin"]     = { link = "GruvboxAqua" },
        Function                  = { link = "GruvboxAqua" },
        -- Strings in warm beige; escapes keep their own colour so they stand out.
        String                    = { fg = muted.beige },
        Character                 = { fg = muted.beige },
        ["@string"]               = { link = "String" },
        ["@lsp.type.string"]      = { link = "String" },
        -- Warnings should stay warm, not inherit the blue that replaced yellow.
        DiagnosticWarn            = { fg = muted.yellow },
        DiagnosticSignWarn        = { fg = muted.yellow },
        DiagnosticFloatingWarn    = { fg = muted.yellow },
        DiagnosticVirtualTextWarn = { fg = muted.yellow },
        DiagnosticUnderlineWarn   = { undercurl = true, sp = muted.yellow },
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
      set(0, "NvimTreeFolderIcon",        { fg = muted.yellow })
      set(0, "NvimTreeRootFolder",        { fg = p.bright_purple, bold = true })
      set(0, "NvimTreeSymlink",           { fg = p.neutral_aqua,  italic = true })
      set(0, "NvimTreeExecFile",          { fg = p.bright_green,  bold = true })
      set(0, "NvimTreeSpecialFile",       { fg = muted.orange, underline = true })
      set(0, "NvimTreeOpenedFile",        { fg = p.light1,     bold = true })
      set(0, "NvimTreeModifiedFile",      { fg = muted.orange })
      set(0, "NvimTreeNormalFile",        { fg = p.light1 })
      set(0, "NvimTreeGitNew",            { fg = p.bright_green })
      set(0, "NvimTreeGitDirty",          { fg = muted.yellow })
      set(0, "NvimTreeGitStaged",         { fg = p.bright_blue })
      set(0, "NvimTreeGitDeleted",        { fg = muted.red })
      set(0, "NvimTreeGitIgnored",        { fg = p.gray })
    end,
  },
}
