return {
  "smjonas/inc-rename.nvim",
  cmd = "IncRename",
  dependencies = {
    { "folke/noice.nvim", optional = true, opts = { presets = { inc_rename = true } } },
  },
  opts = {},
}
