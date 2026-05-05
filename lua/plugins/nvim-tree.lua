return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
      { "<leader>E", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal current file" },
    },
    opts = {
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.set("n", "l", api.node.open.edit, {
          buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "nvim-tree: Open",
        })
        vim.keymap.set("n", "h", api.node.navigate.parent_close, {
          buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "nvim-tree: Close Directory",
        })
      end,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = { enable = true, update_root = false },
      view = { width = 36, side = "left", signcolumn = "yes" },
      renderer = {
        group_empty = true,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
          show = { file = true, folder = true, folder_arrow = true, git = true },
          glyphs = {
            git = {
              unstaged = "●",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "?",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      filters = { dotfiles = false, custom = { "^\\.git$" } },
      git = { enable = true, ignore = false },
      diagnostics = { enable = true, show_on_dirs = true },
      actions = {
        open_file = {
          quit_on_open = false,
          window_picker = { enable = false },
        },
      },
    },
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
