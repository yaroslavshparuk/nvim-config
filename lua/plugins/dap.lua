return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
          ensure_installed = { "netcoredbg", "delve" },
          automatic_installation = true,
          handlers = {},
        },
      },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: toggle breakpoint" },
      { "<leader>dB", function()
        vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
          if cond and cond ~= "" then require("dap").set_breakpoint(cond) end
        end)
      end, desc = "DAP: conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "DAP: continue / start" },
      { "<leader>di", function() require("dap").step_into() end, desc = "DAP: step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "DAP: step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "DAP: step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "DAP: toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "DAP: run last" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP: toggle UI" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "DAP: terminate" },
      { "<leader>dk", function() require("dap.ui.widgets").hover() end, desc = "DAP: hover variable" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      require("nvim-dap-virtual-text").setup({})

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticInfo", linehl = "Visual" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })

      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      local mason_root = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg"
      local netcoredbg = mason_root .. (vim.fn.has("win32") == 1 and "/netcoredbg/netcoredbg.exe" or "/netcoredbg")

      dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg,
        args = { "--interpreter=vscode" },
      }

      local function pick_dll()
        local cwd = vim.fn.getcwd()
        local patterns = {
          cwd .. "/bin/Debug/**/*.dll",
          cwd .. "/**/bin/Debug/**/*.dll",
        }
        local dlls = {}
        for _, p in ipairs(patterns) do
          for _, f in ipairs(vim.fn.glob(p, false, true)) do
            table.insert(dlls, f)
          end
          if #dlls > 0 then break end
        end

        local default = #dlls > 0 and dlls[1] or (cwd .. "/bin/Debug/")
        if #dlls > 1 then
          table.sort(dlls, function(a, b) return vim.fn.getftime(a) > vim.fn.getftime(b) end)
          default = dlls[1]
        end
        return coroutine.create(function(co)
          vim.ui.input({ prompt = "Path to dll: ", default = default, completion = "file" }, function(input)
            coroutine.resume(co, input)
          end)
        end)
      end

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch — pick dll",
          request = "launch",
          program = pick_dll,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
        },
        {
          type = "coreclr",
          name = "Attach to running process",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }
    end,
  },
}
