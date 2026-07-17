return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  keys = {
    { "<Leader>uz", "<Cmd>ColorizerToggle<CR>", desc = "Toggle color highlight" },
  },
  opts = {
    user_default_options = {
      tailwind = true,
      css = true,
    },
    filetypes = {
      "*",
      css = {
        names = true,
      },
      html = {
        names = true,
      },
      lua = {
        names = true,
      },
    },
  },
}
