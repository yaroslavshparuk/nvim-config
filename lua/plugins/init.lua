local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins.theme" },
    { import = "plugins.treesitter" },
    { import = "plugins.lsp" },
    { import = "plugins.easy-dotnet" },
    { import = "plugins.dap" },
    { import = "plugins.completion" },
    { import = "plugins.telescope" },
    { import = "plugins.fff" },
    { import = "plugins.nvim-tree" },
    { import = "plugins.yazi" },
    { import = "plugins.git" },
    { import = "plugins.diffview" },
    { import = "plugins.format" },
    { import = "plugins.ui" },
    { import = "plugins.dashboard" },
    { import = "plugins.editing" },
    { import = "plugins.terminal" },
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
