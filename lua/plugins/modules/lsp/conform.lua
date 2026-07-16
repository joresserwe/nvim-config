return {
  "stevearc/conform.nvim",
  keys = {
    { ";f", function() require("conform").format { async = false } end, desc = "Format buffer" },
    { ";f", function() require("conform").format { async = false } end, mode = "v", desc = "Format buffer(Visual)" },
    { "<Leader>lc", "<cmd>ConformInfo<cr>", desc = "Conform Information" },
  },
}
