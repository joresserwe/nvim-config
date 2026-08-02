local http_ft = { "http", "rest" }

return {
  "mistweaverco/kulala.nvim",
  ft = http_ft,
  opts = {
    global_keymaps_prefix = "<Leader>r",
    global_keymaps = {
      ["Open scratchpad"] = { "<Leader>rb", function() require("kulala").scratchpad() end, ft = http_ft },
      ["Open kulala"] = { "<Leader>ro", function() require("kulala").open() end, ft = http_ft },
      ["Send request"] = { "<Leader>rs", function() require("kulala").run() end, mode = { "n", "v" }, ft = http_ft },
      ["Send all requests"] = { "<Leader>ra", function() require("kulala").run_all() end, mode = { "n", "v" }, ft = http_ft },
      ["Replay the last request"] = { "<Leader>rr", function() require("kulala").replay() end, ft = http_ft },
    },
    lsp = { filetypes = http_ft },
    ui = { default_view = "body" },
  },
}
