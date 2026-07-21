-- Single source of truth for OS/env detection.
-- No side effects; detected once at require time and cached on the module table.
local M = {}

local uname = vim.uv.os_uname()

M.sysname = uname.sysname
M.is_mac = uname.sysname == "Darwin"
M.is_linux = uname.sysname == "Linux"
M.is_windows = uname.sysname:match "Windows" ~= nil

-- WSL detection: env vars first, falling back to the kernel release string.
M.is_wsl = M.is_linux
  and (
    vim.env.WSL_DISTRO_NAME ~= nil
    or vim.env.WSL_INTEROP ~= nil
    or (uname.release or ""):lower():match "microsoft" ~= nil
  )

local profile_file = (vim.env.XDG_STATE_HOME or vim.env.HOME .. "/.local/state")
  .. "/dotfiles/profile"
local ok, lines = pcall(vim.fn.readfile, profile_file)
M.profile = ok and vim.trim(lines[1] or "") or nil
M.is_light = M.profile == "light"

-- User login shell (ensures rc files are sourced). Falls back to sh.
M.shell = vim.env.SHELL or "/bin/sh"

-- WSL domains don't get WEZTERM_PANE, so also detect via TERM_PROGRAM.
-- TERM_PROGRAM can be "WezTerm"/"wezterm"/"WEZ_TERM" depending on env, so match a substring.
M.in_wezterm = vim.env.WEZTERM_PANE ~= nil
  or ((vim.env.TERM_PROGRAM or ""):lower():find "wez") ~= nil
M.in_tmux = vim.env.TMUX ~= nil

--- Whether an executable is on PATH.
---@param name string
---@return boolean
function M.has_exec(name) return vim.fn.executable(name) == 1 end

return M
