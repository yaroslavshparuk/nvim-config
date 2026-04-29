return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>y", "<cmd>Yazi<CR>", desc = "Yazi (current file)" },
      { "<leader>Y", "<cmd>Yazi cwd<CR>", desc = "Yazi (cwd)" },
      { "<leader>yt", "<cmd>Yazi toggle<CR>", desc = "Resume last Yazi" },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<F1>",
        open_file_in_vertical_split = "<C-v>",
        open_file_in_horizontal_split = "<C-x>",
        open_file_in_tab = "<C-t>",
        grep_in_directory = "<C-s>",
        replace_in_directory = "<C-g>",
        cycle_open_buffers = "<Tab>",
        copy_relative_path_to_selected_files = "<C-y>",
        send_to_quickfix_list = "<C-q>",
        change_working_directory = "<C-\\>",
      },
    },
  },
}
