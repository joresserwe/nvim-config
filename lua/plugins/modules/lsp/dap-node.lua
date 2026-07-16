-- JavaScript/TypeScript DAP adapter + default configuration.
-- Runs pwa-node via the mason-installed js-debug-adapter.
return {
  "mfussenegger/nvim-dap",
  optional = true,
  config = function()
    local dap = require "dap"
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          -- mason 2.0 removed get_install_path(); reference the standard path directly.
          vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }
    local js_config = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
      },
    }

    if not dap.configurations.javascript then
      dap.configurations.javascript = js_config
    else
      vim.list_extend(dap.configurations.javascript, js_config)
    end
  end,
}
