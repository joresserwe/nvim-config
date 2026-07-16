-- yazi file-manager floating-window integration.
return {
  "mikavilpas/yazi.nvim",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "sf", "<Cmd>Yazi<CR>", desc = "Yazi (current file)" },
    { "sF", "<Cmd>Yazi cwd<CR>", desc = "Yazi (cwd)" },
  },
  opts = {},
}
