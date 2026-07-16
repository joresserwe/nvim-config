return {
  "craftzdog/solarized-osaka.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    styles = {
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = "transparent", -- style for sidebars, see below
      floats = "transparent", -- style for floating windows
    },
  },
  config = function(_, opts)
    require("solarized-osaka").setup(opts)
    vim.cmd.colorscheme "solarized-osaka"
  end,
}
