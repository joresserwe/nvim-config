return {
  "okuuva/auto-save.nvim",
  version = "^1.0.0",
  event = { "User AstroFile", "InsertEnter" },
  keys = {
    { "<Leader>uA", "<cmd>ASToggle<cr>", desc = "Toggle Autosave" },
  },
  opts = {
    condition = function(buf)
      if not vim.api.nvim_buf_is_valid(buf) then return false end
      if vim.bo[buf].buftype == "acwrite" then return false end
      if vim.bo[buf].readonly then return false end
      return true
    end,
  },
}
