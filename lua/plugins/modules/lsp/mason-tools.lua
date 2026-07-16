return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    opts = require("lsp.installer").mason,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = { automatic_enable = false },
  },
}
