-- Pure Lua script that runs last, after all lazy.nvim plugin loading finishes.
-- Platform/terminal integrations hard to express as plugin specs are split out under lua/integrations/.

require "core.autocmds"
require "core.mappings"
require "lsp.setup"
require("highlights").setup()
require "integrations.term"
require "integrations.clipboard"
require "integrations.memo"
require("plugins.modules.editing-support.ai.claude-pane").setup()

-- The InsertEnter plugin loads stall the first insert ~500ms on light (VDI) hosts.
if require("core.platform").is_light then
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
      vim.defer_fn(
        function() require("lazy").load { plugins = { "blink.cmp", "copilot.lua", "auto-save.nvim", "blink.pairs" } } end,
        1500
      )
    end,
  })
end
