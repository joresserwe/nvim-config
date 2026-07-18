local icons = require "core.icons"

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec", "disable.ft", "disable.bt" },
  opts = {
    icons = {
      group = "",
      rules = false,
      separator = "-",
    },
    spec = {
      { "s", group = "󰖮 Show", mode = { "n", "x" } },
      { "<Leader>p", group = "󰅌 Paste" },
      { "<Leader>s", group = " Session" },
      { "<Leader>a", group = " AI" },
      { "<Leader>l", group = "Language Tools", mode = { "n", "v" } },
      { "<Leader>,", group = "Debugger" },
      { "<Leader>'", group = "Plugins" },
      { "<Leader>b", group = icons.get("Tab", 1) .. "Buffers" },
      { "<Leader>bs", group = icons.get("Sort", 1) .. "Sort Buffers" },
      { "<Leader>f", group = icons.get("Search", 1) .. "Find" },
      { "<Leader>g", group = icons.get("Git", 1) .. "Git" },
      { "<Leader>t", group = icons.get("Terminal", 1) .. "Terminal" },
      { "<Leader>u", group = icons.get("Window", 1) .. "UI/UX" },
    },
    triggers = {
      { "<auto>", mode = "nixsotc" },
      { "s", mode = "nxo" },
    },
    win = {
      border = "rounded",
    },
  },
}
