return {
  "stevearc/conform.nvim",
  keys = {
    { ";f", function() require("conform").format { async = false } end, desc = "Format buffer" },
    { ";f", function() require("conform").format { async = false } end, mode = "v", desc = "Format buffer(Visual)" },
    { "<Leader>lc", "<cmd>ConformInfo<cr>", desc = "Conform Information" },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },

      html = { "stylelint", "prettierd", stop_after_first = true },
      css = { "stylelint", "prettierd", stop_after_first = true },
      scss = { "stylelint", "prettierd", stop_after_first = true },
      less = { "stylelint", "prettierd", stop_after_first = true },
      sh = { "shfmt" },
      zsh = { "shfmt" },
      markdown = { "mdformat" },
    },
  },
}
