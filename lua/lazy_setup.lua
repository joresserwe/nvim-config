require("lazy").setup({
  { import = "plugins.base" },
  { import = "plugins" },
} --[[@as LazySpec]], {
  -- Configure any other `lazy.nvim` configuration options here
  install = { colorscheme = { "solarized-osaka", "habamax" } },
  ui = { backdrop = 100, border = "rounded" },
  performance = {
    rtp = {
      -- disable some rtp plugins, add more to your liking
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
} --[[@as LazyConfig]])
