return {
  "folke/lazydev.nvim",
  ft = "lua",
  cmd = "LazyDev",
  opts_extend = { "library" },
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "lazy.nvim", words = { "Lazy" } },
    },
  },
}
