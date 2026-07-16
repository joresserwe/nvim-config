local user = require "highlights.colors"

-- Color utilities ---------------------------------------------------------

local function hex_to_rgb(hex)
  hex = string.lower(hex)
  return {
    r = tonumber(hex:sub(2, 3), 16),
    g = tonumber(hex:sub(4, 5), 16),
    b = tonumber(hex:sub(6, 7), 16),
  }
end

local function rgb_to_hex(rgb)
  return string.format("#%02x%02x%02x", rgb.r, rgb.g, rgb.b)
end

local function rgba(r, g, b, alpha, base)
  local base_rgb = hex_to_rgb(base)
  return rgb_to_hex {
    r = (1 - alpha) * base_rgb.r + alpha * r,
    g = (1 - alpha) * base_rgb.g + alpha * g,
    b = (1 - alpha) * base_rgb.b + alpha * b,
  }
end

--- Larger alpha moves the result closer to hexColor.
local function blend(hexColor, alpha, base)
  local rgb = hex_to_rgb(hexColor)
  return rgba(rgb.r, rgb.g, rgb.b, alpha, base)
end

-- Extract theme palette ---------------------------------------------------

local function palette()
  local function get_fg(name)
    local h = vim.api.nvim_get_hl(0, { name = name, link = false })
    return h.fg and string.format("#%06x", h.fg)
  end
  local function get_bg(name)
    local h = vim.api.nvim_get_hl(0, { name = name, link = false })
    return h.bg and string.format("#%06x", h.bg)
  end
  return {
    fg = get_fg "Normal",
    bg = get_bg "Normal" or "#1e1e2e",
    comment = get_fg "Comment" or "#545c7e",
    accent = get_fg "Function" or "#6495ED",
    string = get_fg "String" or "#00FF00",
    error = get_fg "DiagnosticError" or "#DC143C",
    warn = get_fg "DiagnosticWarn" or "#FF8C00",
    info = get_fg "DiagnosticInfo" or "#00BFFF",
    hint = get_fg "DiagnosticHint" or "#9370DB",
  }
end

-- Resolve semantic colors (user config → theme fallback) ------------------

local _cache = nil

local function resolve()
  if _cache then return _cache end
  local p = palette()
  local inactive = user.inactive or p.comment
  _cache = {
    transparent_bg = user.transparent_bg,
    bg = user.bg or p.bg,
    fg = user.fg or p.fg,
    accent = user.accent or p.accent,
    indicator = user.indicator or p.string,
    inactive = inactive,
    unfocused = user.unfocused or blend(p.fg, 0.5, inactive),
    danger = user.danger or p.error,
    scrollbar = user.scrollbar or p.accent,
    winsep = user.winsep or p.accent,
  }
  return _cache
end

local function invalidate() _cache = nil end

-- For external access (used as require("highlights").accent, e.g. from scrollbar)
local M = { invalidate = invalidate }
setmetatable(M, {
  __index = function(_, k)
    return resolve()[k]
  end,
})

function M.build()
  invalidate()
  local c = resolve()
  local NONE = "NONE"
  local bg = c.transparent_bg and NONE or c.bg
  return user.highlights(c, bg)
end

local function apply()
  if not vim.g.colors_name then return end
  pcall(function()
    for group, spec in pairs(M.build() or {}) do
      vim.api.nvim_set_hl(0, group, spec)
    end
  end)
end

function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Load custom highlights from user configuration",
    group = vim.api.nvim_create_augroup("user_highlights", { clear = true }),
    callback = apply,
  })
  apply()
end

return M
