local function find_csharp_project_root(start_dir)
  local found = vim.fs.find(function(name)
    return name:match("%.sln$") or name:match("%.slnx$") or name:match("%.csproj$")
  end, { upward = true, path = start_dir, type = "file" })[1]
  if found then return vim.fs.dirname(found) end
end

local function run_dotnet_format(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then return end
  local root = find_csharp_project_root(vim.fs.dirname(filepath))
  if not root then
    vim.notify("dotnet format: no .sln/.slnx/.csproj found", vim.log.levels.WARN)
    return
  end
  vim.cmd("write")
  vim.fn.jobstart({ "dotnet", "format", "--include", filepath }, {
    cwd = root,
    on_exit = function(_, code)
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_call(bufnr, function() vim.cmd("checktime") end)
        end
        if code ~= 0 then
          vim.notify("dotnet format exited with code " .. code, vim.log.levels.WARN)
        end
      end)
    end,
  })
end

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = { "VeryLazy" },
    opts = {
      ensure_installed = { "prettier", "stylua", "shfmt", "goimports", "gofumpt" },
      run_on_start = true,
    },
  },
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          if vim.bo.filetype == "cs" then
            run_dotnet_format(vim.api.nvim_get_current_buf())
          else
            require("conform").format({ async = true, lsp_format = "fallback" })
          end
        end,
        mode = { "n", "v" },
        desc = "Format buffer / range",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        go = { "goimports", "gofumpt" },
      },
    },
  },
}
