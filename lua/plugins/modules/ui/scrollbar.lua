return {
  {
    "lewis6991/satellite.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      if require("core.platform").is_light then
        -- Full refreshes stutter software-rendered displays even rate-limited
        -- to 10/s; the heavy part is handler re-render, not the bar move.
        -- Must wrap before setup(): enable() captures schedule_refresh into
        -- autocmds.
        local view = require "satellite.view"
        local handlers = require "satellite.handlers"

        local scrolling = false
        local render = handlers.render
        handlers.render = function(...)
          if not scrolling then return render(...) end
        end

        local full = view.schedule_refresh
        local settle = require("satellite.util").debounce_trailing(function()
          scrolling = false
          full()
        end, 150)

        local gate = assert(vim.uv.new_timer())
        view.schedule_refresh = function()
          scrolling = true
          if not gate:is_active() then
            gate:start(80, 0, function() end)
            full()
          end
          settle()
        end
      end
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
