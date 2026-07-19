local user = require "highlights.colors"

-- Color utilities ---------------------------------------------------------

local function to_hex(color)
  if color:sub(1, 1) == "#" then return color end
  return string.format("#%06x", vim.api.nvim_get_color_by_name(color))
end

local function hex_to_rgb(hex)
  return {
    r = tonumber(hex:sub(2, 3), 16),
    g = tonumber(hex:sub(4, 5), 16),
    b = tonumber(hex:sub(6, 7), 16),
  }
end

--- Larger alpha moves the result closer to color.
local function blend(color, alpha, base)
  local c = hex_to_rgb(to_hex(color))
  local b = hex_to_rgb(to_hex(base))
  return string.format(
    "#%02x%02x%02x",
    (1 - alpha) * b.r + alpha * c.r,
    (1 - alpha) * b.g + alpha * c.g,
    (1 - alpha) * b.b + alpha * c.b
  )
end

-- Extract theme palette ---------------------------------------------------

local function hl_color(name, attr)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  return hl[attr] and string.format("#%06x", hl[attr])
end

local function palette()
  return {
    fg = hl_color("Normal", "fg"),
    bg = hl_color("Normal", "bg") or "#1e1e2e",
    comment = hl_color("Comment", "fg") or "#545c7e",
    accent = hl_color("Function", "fg") or "#6495ED",
    string = hl_color("String", "fg") or "#00FF00",
    error = hl_color("DiagnosticError", "fg") or "#DC143C",
    warn = hl_color("DiagnosticWarn", "fg") or "#FF8C00",
    info = hl_color("DiagnosticInfo", "fg") or "#00BFFF",
    hint = hl_color("DiagnosticHint", "fg") or "#9370DB",
  }
end

-- Resolve semantic colors (user config → theme fallback) ------------------

local function resolve()
  local p = palette()
  local inactive = user.inactive or p.comment
  return {
    transparent_bg = user.transparent_bg,
    bg = user.bg or p.bg,
    fg = user.fg or p.fg,
    accent = user.accent or p.accent,
    indicator = user.indicator or p.string,
    inactive = inactive,
    unfocused = user.unfocused or blend(p.fg, 0.5, inactive),
    danger = user.danger or p.error,
    scrollbar = user.scrollbar or p.accent,
    linenr = user.linenr or p.comment,
    winsep = user.winsep or p.accent,
  }
end

local M = {}

function M.build()
  local c = resolve()
  local bg = c.transparent_bg and "NONE" or c.bg
  return user.highlights(c, bg, blend)
end

--- Themes often paint float borders with a panel background; keep only the line color.
local function strip_border_backgrounds()
  for name, def in pairs(vim.api.nvim_get_hl(0, {})) do
    if name:sub(-6) == "Border" and not def.link and def.bg then
      def.bg = nil
      vim.api.nvim_set_hl(0, name, def)
    end
  end
end

local function strip_sign_backgrounds()
  for name in pairs(vim.api.nvim_get_hl(0, {})) do
    local gutter_sign = name:sub(1, 14) == "DiagnosticSign"
      or (
        name:sub(1, 8) == "GitSigns"
        and not (
          name:find "Ln"
          or name:find "Inline"
          or name:find "Preview"
          or name:find "VirtLn"
          or name:find "Blame"
        )
      )
    if gutter_sign then
      local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      if hl.bg then
        hl.bg = nil
        vim.api.nvim_set_hl(0, name, hl)
      end
    end
  end
end

local function apply()
  if not vim.g.colors_name then return end
  if user.transparent_bg then
    strip_border_backgrounds()
    strip_sign_backgrounds()
  end
  for group, spec in pairs(M.build()) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("user_highlights", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Load custom highlights from user configuration",
    group = group,
    callback = apply,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    group = group,
    callback = function()
      if user.transparent_bg then strip_sign_backgrounds() end
    end,
  })
  apply()
end

return M
