-- Unified list for diagnostics, references, and quickfix.
return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "sq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
    { "sd", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
    { "sD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
    { "sr", "<cmd>Trouble lsp_references toggle<cr>", desc = "References (Trouble)" },
    { "si", "<cmd>Trouble lsp_implementations toggle<cr>", desc = "Implementations (Trouble)" },
  },
  opts = {
    focus = true,
    auto_close = true,
  },
  init = function()
    -- Open with Trouble instead of the built-in quickfix window.
    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
      callback = function()
        vim.schedule(function() vim.cmd "Trouble qflist open" end)
      end,
    })
  end,
}
