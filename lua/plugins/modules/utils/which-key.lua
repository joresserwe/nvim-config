return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "s", group = "󰖮 Show", mode = { "n", "x" } },
      { "<Leader>p", group = "󰅌 Paste" },
      { "<Leader>s", group = " Session" },
      { "<Leader>a", group = " AI" },
      { "<Leader>,", group = "Debugger" },
      { "<Leader>'", group = "Plugins" },
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
