return {
  {
    "joresserwe/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers", -- set to "tabs" to only show tabpages instead
        offsets = {
          {
            filetype = "neo-tree",
            -- text_align = "left", --"left" | "center" | "right"
            -- text = function() return vim.fn.getcwd() end,
            -- highlight = "Directory",
          },
        },
        name_formatter = function(buf)
          -- local zoom = buf.bufnr == vim.api.nvim_get_current_buf() and vim.fn["zoom#statusline"]() or ""
          -- return buf.name .. zoom
        end,
        -- style_preset = require("bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
        diagnostics = "nvim_lsp", -- false | "nvim_lsp" | "coc",
        diagnostics_indicator = function(_, level, diagnostics_dict, context)
          if not context.buffer:current() then return "" end -- visible()
          local icon = level:match "error" and " " .. diagnostics_dict["error"]
            or level:match "warning" and " " .. diagnostics_dict["warning"]
            or level:match "info" and "󰋼 " .. diagnostics_dict["info"]
            or "󰌵 " .. diagnostics_dict["hint"]
          return icon
        end,
        -- separator_style = { " ", " " }, --"slant" | "slope" | "thick" | "thin" | { "", "" }
        separator_style = { "", "" },
        indicator = {
          style = "icon", --'icon' | 'underline' | 'none',
          icon = "",
          -- visible_icon = "",
          visible_icon = "",
        },
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        move_wraps_at_ends = false, -- whether or not the move command "wraps" at the first or last position
        -- nvim
        custom_filter = function(bufnum, _) return require("core.winbufs").contains(bufnum) end,
      },
    },
  },
}
