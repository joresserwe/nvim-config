return {
  "folke/snacks.nvim",
  keys = {
    { "fd", function() require("snacks").picker.diagnostics() end, desc = "Search diagnostics" },
    { "<Leader>f`", function() require("snacks").picker.marks() end, desc = "Find marks" },
    { "<Leader>f'", function() require("snacks").picker.registers() end, desc = "Find registers" },
    { "<Leader>f/", function() require("snacks").picker.grep() end, desc = "Find words" },
    { "<Leader>f?", function() require("snacks").picker.grep { hidden = true, ignored = false } end, desc = "Find words(숨김파일포함)" },
    { "<Leader>fe", function() require("snacks").picker.recent { filter = { cwd = true } } end, desc = "Find history in CWD" },
    { "<Leader>fE", function() require("snacks").picker.recent() end, desc = "Find history All Path" },
    { "<Leader>fS", function() require("snacks").picker.lsp_symbols() end, desc = "Search symbols (Snacks)" },
    { "<Leader>fz", function() require("snacks").picker.zoxide() end, desc = "Find directories" },
    { "<Leader>fu", function() require("snacks").picker.undo() end, desc = "Find Undo" },
    { "<Leader>fl", function() require("snacks").picker.lines() end, desc = "Find Lines" },
    { "su", function() require("snacks").picker.undo() end, desc = "Find Undo" },
  },
  ---@type snacks.Config
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ["<c-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
            ["<c-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
            ["<c-p>"] = { "focus_preview", mode = { "i", "n" } },
            ["<c-n>"] = false,
          },
        },
        list = {
          keys = {
            ["<c-l>"] = "preview_scroll_right",
            ["<c-h>"] = "preview_scroll_left",
            ["<c-p>"] = "focus_preview",
            ["<c-n>"] = false,
          },
        },
        preview = {
          keys = {
            ["<c-i>"] = "focus_input",
            ["<c-p>"] = "focus_list",
            ["<c-l>"] = "focus_list",
          },
        },
      },
      sources = {
        notifications = {
          layout = {
            layout = {
              box = "vertical", -- 전체 구조를 수직으로 배치
              width = 0.7,
              height = 0.6,
              border = "rounded",
              { win = "input", height = 1, border = "bottom", title = "Filter", title_pos = "center" },
              { win = "list", border = "rounded", title = "Notifications", title_pos = "center" },
              { win = "preview", height = 0.5, border = "none" },
            },
          },
          confirm = "close",
          formatters = { severity = { level = true } },
          focus = "list",
        },
      },
    },
  },
}
