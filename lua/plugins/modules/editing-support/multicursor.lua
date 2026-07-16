return {
  "smoka7/multicursors.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvimtools/hydra.nvim",
  },
  cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
  keys = {
    { "mm", function() require("multicursors").start() end, desc = "multicursor start" },
    { "m/", function() require("multicursors").new_pattern() end, desc = "multicursor search" },
    { "mm", function() require("multicursors").search_visual() end, mode = "x", desc = "multicursor search" },
  },
  opts = {
    normal_keys = {
      ["m"] = {
        method = function() require("multicursors.normal_mode").find_next() end,
        opts = { desc = "Find next" },
      },
      ["M"] = {
        method = function() require("multicursors.normal_mode").find_prev() end,
        opts = { desc = "Find prev" },
      },
      ["n"] = { method = false },
    },
  },
}
