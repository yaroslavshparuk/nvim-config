return {
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
      "DiffviewRefresh",
    },
    keys = {
      { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "Branch history (Diffview)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", desc = "Current file history (Diffview)" },
      {
        "<leader>gco",
        function()
          vim.ui.input({ prompt = "Commit SHA: " }, function(sha)
            if sha and sha ~= "" then
              vim.cmd("DiffviewOpen " .. sha .. "^.." .. sha)
            end
          end)
        end,
        desc = "Review commit (Diffview)",
      },
      {
        "<leader>gcb",
        function()
          local function sh(cmd)
            local out = vim.fn.systemlist(cmd)
            if vim.v.shell_error ~= 0 then return nil end
            return out[1]
          end
          local ref = sh("git symbolic-ref --quiet --short refs/remotes/origin/HEAD")
          if not ref then
            for _, b in ipairs({ "origin/dev", "origin/main", "origin/master" }) do
              if sh("git rev-parse --verify --quiet " .. b) then
                ref = b
                break
              end
            end
          end
          if not ref then
            vim.notify("Could not determine default remote branch", vim.log.levels.ERROR)
            return
          end
          vim.cmd("DiffviewOpen " .. ref .. "...HEAD")
        end,
        desc = "Review branch vs default (Diffview)",
      },
      { "<leader>gcc", "<cmd>DiffviewClose<CR>", desc = "Close Diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = { layout = "diff3_mixed" },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { width = 35 },
      },
    },
  },
}
