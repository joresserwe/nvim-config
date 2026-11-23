local css_var = { parsers = { css_var = { enable = true } } }

return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  keys = {
    { "<Leader>uz", "<Cmd>ColorizerToggle<CR>", desc = "Toggle color highlight" },
  },
  opts = {
    options = {
      parsers = {
        css = true,
        css_var = { enable = false },
      },
    },
    filetypes = {
      "*",
      css = css_var,
      scss = css_var,
      less = css_var,
      html = css_var,
    },
  },
}
