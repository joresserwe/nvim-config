-- Highlight the active window's border color (tmux style).
---@type LazySpec
return {
  {
    "nvim-zh/colorful-winsep.nvim",
    event = "WinLeave",
    opts = {
      border = "single",
      animate = { enabled = false },
      excluded_ft = {
        "neo-tree",
        "noice",
        "qf",
        "trouble",
        "snacks_terminal",
        "snacks_picker_input",
        "mason",
        "lazy",
      },
    },
  },
}