local function is_valid(bufnr) return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted end
local function is_large(bufnr) return vim.b[bufnr].large_buf == true end

return {
  "brenoprata10/nvim-highlight-colors",
  event = { "User AstroFile", "InsertEnter" },
  cmd = "HighlightColors",
  keys = {
    { "<Leader>uz", function() vim.cmd.HighlightColors "Toggle" end, desc = "Toggle color highlight" },
  },
  opts = {
    enable_named_colors = false,
    virtual_symbol = "\u{f14fb}",
    exclude_buffer = function(bufnr) return is_large(bufnr) or not is_valid(bufnr) end,
  },
}
