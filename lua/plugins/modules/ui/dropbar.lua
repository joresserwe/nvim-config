return {
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    cond = function() return not require("core.platform").is_light end,
    opts = {
      bar = {
        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils = require("dropbar.utils")
          if vim.bo[buf].ft == "markdown" then return { sources.markdown } end
          return {
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
            }),
          }
        end,
      },
    },
  },
}
