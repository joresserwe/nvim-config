-- Zed-style LSP symbol navigator (keeps hierarchy, kind filtering, multi-select).
return {
  "bassamsdata/namu.nvim",
  event = "VeryLazy",
  keys = { { "<Leader>fs", "<cmd>Namu symbols<cr>", desc = "Search symbols (Namu)" } },
  opts = {
    namu_symbols = {
      options = {
        window = {
          width_ratio = 0.8,
          height_ratio = 0.8,
        },
      },
    },
  },
}
