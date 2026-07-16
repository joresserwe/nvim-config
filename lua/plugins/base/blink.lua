return {
  "saghen/blink.cmp",
  version = "^1",
  event = { "InsertEnter", "CmdlineEnter" },
  opts_extend = { "sources.default", "cmdline.sources", "term.sources" },
  opts = {
    -- The <Leader>uc/uC toggles flip vim.b/g.completion.
    enabled = function()
      if vim.bo.buftype == "prompt" then return false end
      return vim.F.if_nil(vim.b.completion, vim.g.completion, true)
    end,
    fuzzy = { implementation = "prefer_rust" },
    cmdline = {
      keymap = { ["<End>"] = { "hide", "fallback" } },
      completion = { ghost_text = { enabled = false } },
    },
  },
  keys = {
    {
      "<Leader>uc",
      function()
        if vim.b.completion == nil then vim.b.completion = vim.F.if_nil(vim.g.completion, true) end
        vim.b.completion = not vim.b.completion
        vim.notify(string.format("Buffer completion %s", vim.b.completion and "on" or "off"))
      end,
      desc = "Toggle autocompletion (buffer)",
    },
    {
      "<Leader>uC",
      function()
        vim.g.completion = not vim.F.if_nil(vim.g.completion, true)
        vim.notify(string.format("Global completion %s", vim.g.completion and "on" or "off"))
      end,
      desc = "Toggle autocompletion (global)",
    },
  },
}
