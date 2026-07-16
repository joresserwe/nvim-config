return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  cmd = {
    "MasonToolsInstall",
    "MasonToolsInstallSync",
    "MasonToolsUpdate",
    "MasonToolsUpdateSync",
    "MasonToolsClean",
  },
  dependencies = { "mason-org/mason.nvim" },
  -- Load alongside mason.nvim (immediately if already loaded, else wait on User LazyLoad).
  init = function(plugin)
    local lazy_config = require "lazy.core.config"
    local load = function() require("lazy").load { plugins = { plugin.name } } end
    if vim.tbl_get(lazy_config.plugins, "mason.nvim", "_", "loaded") then
      vim.schedule(load)
    else
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(args)
          if args.data == "mason.nvim" then
            load()
            return true
          end
        end,
      })
    end
  end,
  opts_extend = { "ensure_installed" },
  opts = {
    ensure_installed = {},
    integrations = { ["mason-lspconfig"] = false, ["mason-null-ls"] = false, ["mason-nvim-dap"] = false },
  },
  config = function(_, opts)
    local mti = require "mason-tool-installer"
    mti.setup(opts)
    if opts.run_on_start ~= false then mti.run_on_start() end
  end,
}
