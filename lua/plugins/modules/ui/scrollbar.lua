return {
  {
    "lewis6991/satellite.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      -- A visible float forces the TUI to repaint the whole window on every
      -- scrolled line (~30KB per line, ~1.5KB without one), hence the bars
      -- are closed while scrolling.
      local view = require "satellite.view"

      local scrolling = false
      local refresh = view.refresh_bars
      view.refresh_bars = function()
        if not scrolling then refresh() end
      end

      local settle = require("satellite.util").debounce_trailing(function()
        scrolling = false
        refresh()
      end, 150)

      vim.api.nvim_create_autocmd("WinScrolled", {
        group = vim.api.nvim_create_augroup("satellite_autohide", {}),
        callback = function()
          if not scrolling then
            scrolling = true
            view.remove_bars()
          end
          settle()
        end,
      })

      require("satellite").setup(opts)
    end,
    opts = {
      winblend = 0,
      excluded_filetypes = {
        "dropbar_menu",
        "dropbar_menu_fzf",
        "DressingInput",
        "noice",
        "prompt",
      },
      handlers = {
        cursor = { enable = true },
        search = { enable = true },
        diagnostic = { enable = true },
        gitsigns = { enable = true, overlap = true },
        marks = { enable = true },
        quickfix = { enable = true },
      },
    },
  },
}
