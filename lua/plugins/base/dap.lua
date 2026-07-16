local function is_available(plugin) return require("lazy.core.config").spec.plugins[plugin] ~= nil end

return {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "mfussenegger/nvim-dap", "mason-org/mason.nvim" },
      cmd = { "DapInstall", "DapUninstall" },
      opts_extend = { "ensure_installed" },
      opts = { ensure_installed = {}, handlers = {} },
      config = function(_, opts)
        if is_available "mason-tool-installer.nvim" then opts.ensure_installed = nil end
        require("mason-nvim-dap").setup(opts)
      end,
    },
  },
  init = function()
    local icons = require "core.icons"
    local signs = {
      DapBreakpoint = { text = icons.get "DapBreakpoint", texthl = "DiagnosticInfo" },
      DapBreakpointCondition = { text = icons.get "DapBreakpointCondition", texthl = "DiagnosticInfo" },
      DapBreakpointRejected = { text = icons.get "DapBreakpointRejected", texthl = "DiagnosticError" },
      DapLogPoint = { text = icons.get "DapLogPoint", texthl = "DiagnosticInfo" },
      DapStopped = { text = icons.get "DapStopped", texthl = "DiagnosticWarn" },
    }
    for name, def in pairs(signs) do
      vim.fn.sign_define(name, def)
    end
  end,
  -- showkey -a 로 확인한 수정자 조합 function 키 (Shift/Control 포함)
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Debugger: Start" },
    { "<F6>", function() require("dap").pause() end, desc = "Debugger: Pause" },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debugger: Toggle Breakpoint" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debugger: Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debugger: Step Into" },
    { "<F17>", function() require("dap").terminate() end, desc = "Debugger: Stop" },
    {
      "<F21>",
      function()
        vim.ui.input({ prompt = "Condition: " }, function(condition)
          if condition then require("dap").set_breakpoint(condition) end
        end)
      end,
      desc = "Debugger: Conditional Breakpoint",
    },
    { "<F23>", function() require("dap").step_out() end, desc = "Debugger: Step Out" },
    { "<F29>", function() require("dap").restart_frame() end, desc = "Debugger: Restart" },
  },
  config = function()
    local vscode = require "dap.ext.vscode"
    local parser, cleaner
    vscode.json_decode = function(str)
      if cleaner == nil then
        local ok, plenary = pcall(require, "plenary.json")
        cleaner = ok and function(s) return plenary.json_strip_comments(s, {}) end or false
      end
      if not parser then
        local ok, json5 = pcall(require, "json5")
        parser = ok and json5.parse or function(s) return vim.json.decode(s, { skip_comments = true }) end
      end
      if type(cleaner) == "function" then str = cleaner(str) end
      local ok, parsed = pcall(parser, str)
      if not ok then
        vim.notify("Error parsing `.vscode/launch.json`.", vim.log.levels.ERROR)
        parsed = {}
      end
      return parsed
    end
  end,
}
