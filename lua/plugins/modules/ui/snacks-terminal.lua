return {
  "folke/snacks.nvim",
  keys = {
    {
      "<Leader>t-",
      function() require("snacks").terminal.toggle(nil, { win = { position = "bottom", height = 10 } }) end,
      desc = "Terminal horizontal split",
    },
    {
      "<Leader>t\\",
      function() require("snacks").terminal.toggle(nil, { win = { position = "right", width = 80 } }) end,
      desc = "Terminal vertical split",
    },
  },
}
