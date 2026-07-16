return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<Leader>,b", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (F9)" },
      { "<Leader>,B", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" },
      { "<Leader>,c", function() require("dap").continue() end, desc = "Start/Continue (F5)" },
      {
        "<Leader>,C",
        function()
          vim.ui.input({ prompt = "Condition: " }, function(condition)
            if condition then require("dap").set_breakpoint(condition) end
          end)
        end,
        desc = "Conditional Breakpoint (S-F9)",
      },
      { "<Leader>,i", function() require("dap").step_into() end, desc = "Step Into (F11)" },
      { "<Leader>,o", function() require("dap").step_over() end, desc = "Step Over (F10)" },
      { "<Leader>,O", function() require("dap").step_out() end, desc = "Step Out (S-F11)" },
      { "<Leader>,q", function() require("dap").close() end, desc = "Close Session" },
      { "<Leader>,Q", function() require("dap").terminate() end, desc = "Terminate Session (S-F5)" },
      { "<Leader>,p", function() require("dap").pause() end, desc = "Pause (F6)" },
      { "<Leader>,r", function() require("dap").restart_frame() end, desc = "Restart (C-F5)" },
      { "<Leader>,R", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<Leader>,s", function() require("dap").run_to_cursor() end, desc = "Run To Cursor" },
    },
  },
  {
    "igorlfs/nvim-dap-view",
    version = "1.*",
    dependencies = { "mfussenegger/nvim-dap" },
    cmd = { "DapViewOpen", "DapViewClose", "DapViewToggle" },
    keys = {
      { "<Leader>,u", "<cmd>DapViewToggle<cr>", desc = "Toggle Debugger UI" },
    },
    opts = {},
  },
}
