return {
  {
    "lewis6991/satellite.nvim",
    event = "VeryLazy",
    opts = {
      winblend = 0,
      excluded_filetypes = {
        "dropbar_menu",
        "dropbar_menu_fzf",
        "DressingInput",
        "noice",
        "prompt",
      },
      handlers = {
        cursor = { enable = true },
        search = { enable = true },
        diagnostic = { enable = true },
        gitsigns = { enable = true, overlap = true },
        marks = { enable = true },
        quickfix = { enable = true },
      },
    },
  },
}
