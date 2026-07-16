return {
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = { { "sh", "<cmd>Outline<CR>", desc = "Symbols outline(Hierarchy)" } },
    opts = {
      outline_window = {
        position = "right",
        width = 25,
      },
      symbol_folding = {
        autofold_depth = 1,
      },
    },
  },
}
