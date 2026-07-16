return {
  "folke/todo-comments.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
    { "folke/snacks.nvim", optional = true },
  },
  cmd = { "TodoTrouble", "TodoLocList", "TodoQuickFix" },
  event = "User AstroFile",
  keys = {
    { "]T", function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
    { "[T", function() require("todo-comments").jump_prev() end, desc = "Previous TODO comment" },
  },
  opts = {},
}
