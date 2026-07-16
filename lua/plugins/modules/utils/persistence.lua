return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<Leader>ss", function() require("persistence").load() end, desc = "Load current dir session" },
      { "<Leader>sl", function() require("persistence").select() end, desc = "Select session" },
      { "<Leader>sd", function() require("persistence").stop() end, desc = "Stop session tracking" },
    },
  },
}
