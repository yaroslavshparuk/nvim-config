return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSUpdateSync" },
    opts = {
      ensure_installed = {
        "c_sharp",
        "angular",
        "typescript",
        "javascript",
        "tsx",
        "html",
        "css",
        "scss",
        "json",
        "jsonc",
        "yaml",
        "lua",
        "luadoc",
        "vim",
        "vimdoc",
        "bash",
        "powershell",
        "markdown",
        "markdown_inline",
        "regex",
        "diff",
        "gitcommit",
        "gitignore",
      },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = false,
          node_decremental = "<BS>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)

      -- Neovim 0.12 always passes captures as TSNode[] to query directives.
      -- nvim-treesitter master is unmaintained and still reads them as a single
      -- TSNode, which crashes on markdown fenced code blocks. Re-register the
      -- offending directive with the new shape.
      local query = require("vim.treesitter.query")
      local aliases = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
      query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
        local nodes = match[pred[2]]
        local node = nodes and nodes[1]
        if not node then return end
        local alias = vim.treesitter.get_node_text(node, bufnr):lower()
        local ft = vim.filetype.match({ filename = "a." .. alias })
        metadata["injection.language"] = ft or aliases[alias] or alias
      end, { force = true })
    end,
  },
}
