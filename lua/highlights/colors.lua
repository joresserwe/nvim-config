-- User color settings.
-- nil follows the theme color automatically.
-- A direct color value ("#RRGGBB") overrides the theme with that color.

local NONE = "NONE"

return {
  transparent_bg = true,

  -- semantic colors
  bg = nil, -- background
  fg = nil, -- foreground
  accent = nil, -- primary accent (winbar, scrollbar, etc.)
  indicator = require("highlights.palette").lime, -- active tab indicator
  inactive = nil, -- inactive elements (inactive tabs, winbar, etc.)
  unfocused = nil, -- unfocused elements
  danger = require("highlights.palette").crimson, -- unfocused indicator
  scrollbar = require("highlights.palette").slate_blue, -- scrollbar handle
  winsep = nil, -- active window separator (colorful-winsep)

  --- highlight group definitions (c: resolved semantic colors, bg: transparency-adjusted background)
  ---@param c table
  ---@param bg string
  highlights = function(c, bg)
    return {
      LineNr = { fg = require("highlights.palette").dim_gray },
      LineNrAbove = { fg = require("highlights.palette").dim_gray },
      LineNrBelow = { fg = require("highlights.palette").dim_gray },

      Normal = { bg = bg },
      NormalNC = { bg = bg },
      NormalFloat = { bg = bg },
      FloatTitle = { bg = bg },
      StatusLine = { fg = NONE, bg = NONE },
      StatusLineNC = { fg = NONE, bg = NONE },

      WinBar = { fg = c.accent, bg = NONE },
      WinBarNC = { fg = c.inactive, bg = bg },

      NeoTreeNormal = { bg = bg },
      NeoTreeNormalNC = { bg = bg },

      TabLineFill = { bg = NONE },
      BufferLineBackground = { fg = c.inactive, bg = NONE },
      BufferLineBufferSelected = { bg = NONE },
      BufferLineBufferVisible = { fg = c.unfocused, bg = NONE },

      BufferLineDuplicate = { fg = c.inactive, bg = NONE },
      BufferLineDuplicateSelected = { bg = NONE, bold = true, italic = true },
      BufferLineDuplicateVisible = { fg = c.unfocused, bg = NONE },

      BufferLineSeparator = { fg = c.bg, bg = NONE },
      BufferLineSeparatorSelected = { fg = NONE, bg = c.indicator },
      BufferLineSeparatorVisible = { fg = c.bg, bg = NONE },

      BufferLineIndicatorSelected = { fg = c.indicator, bg = NONE },
      BufferLineIndicatorVisible = { fg = c.danger, bg = NONE },

      BufferLineModified = { bg = NONE },
      BufferLineModifiedSelected = { bg = NONE },
      BufferLineModifiedVisible = { bg = NONE },

      SatelliteBar = { bg = c.scrollbar },

      ColorfulWinSep = { fg = c.winsep },

      BufferLineHintVisible = { fg = c.unfocused },
      BufferLineInfoVisible = { fg = c.unfocused },
      BufferLineWarningVisible = { fg = c.unfocused },
      BufferLineErrorVisible = { fg = c.unfocused },
    }
  end,
}
