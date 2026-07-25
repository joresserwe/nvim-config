return {
  "max397574/better-escape.nvim",
  event = "VeryLazy",
  opts = function()
    return {
      -- Light (VDI) hosts: >300ms input jitter between keys cancels the sequence.
      timeout = require("core.platform").is_light and 600 or 300,
      default_mappings = false,
      mappings = {
        i = { j = { k = "<Esc>", j = "<Esc>" } },
      },
    }
  end,
}
