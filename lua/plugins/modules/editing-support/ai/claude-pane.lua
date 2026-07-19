-- Run the Claude CLI directly in an external terminal pane.
-- claudecode.nvim's external provider reuses this module's pane-split logic.
-- Panes created here are auto-cleaned on nvim exit.
local platform = require "core.platform"

local M = {}

---@type string[]
local pane_ids = {}

---@class ClaudePaneBackend
---@field is_active fun(): boolean
---@field current_pane fun(): string?
---@field pane_size fun(target: string): integer?, integer?
---@field split_cmd fun(target: string, horizontal: boolean, percent: string, env_table: table?, shell_cmd: string): string[]
---@field kill fun(id: string)

---@type table<string, ClaudePaneBackend>
local backend_defs = {
  wezterm = {
    is_active = function() return platform.in_wezterm end,
    current_pane = function() return vim.env.WEZTERM_PANE end,
    pane_size = function(target)
      local info = vim.fn.system "wezterm cli list --format json 2>/dev/null"
      local ok, panes = pcall(vim.json.decode, info)
      if not ok then return nil, nil end
      for _, p in ipairs(panes) do
        if tostring(p.pane_id) == tostring(target) then return p.size.cols, p.size.rows end
      end
      return nil, nil
    end,
    split_cmd = function(target, horizontal, percent, env_table, shell_cmd)
      local cmd = {
        "wezterm",
        "cli",
        "split-pane",
        "--pane-id",
        tostring(target),
        horizontal and "--right" or "--bottom",
        "--percent",
        percent,
      }
      if env_table then
        for k, v in pairs(env_table) do
          table.insert(cmd, "--env")
          table.insert(cmd, k .. "=" .. v)
        end
      end
      vim.list_extend(cmd, { "--", platform.shell, "-lc", shell_cmd })
      return cmd
    end,
    kill = function(id) vim.fn.system("wezterm cli kill-pane --pane-id " .. id) end,
  },
  tmux = {
    is_active = function() return platform.in_tmux end,
    current_pane = function()
      return vim.env.TMUX_PANE or vim.trim(vim.fn.system "tmux display-message -p '#{pane_id}'")
    end,
    pane_size = function(target)
      local cols = tonumber(vim.fn.system("tmux display -p -t " .. target .. " '#{pane_width}'"))
      local rows = tonumber(vim.fn.system("tmux display -p -t " .. target .. " '#{pane_height}'"))
      return cols, rows
    end,
    split_cmd = function(target, horizontal, percent, env_table, shell_cmd)
      local cmd =
        { "tmux", "split-window", horizontal and "-h" or "-v", "-l", percent .. "%", "-P", "-F", "#{pane_id}", "-t", target }
      if env_table then
        for k, v in pairs(env_table) do
          table.insert(cmd, "-e")
          table.insert(cmd, k .. "=" .. v)
        end
      end
      vim.list_extend(cmd, { platform.shell, "-lc", shell_cmd })
      return cmd
    end,
    kill = function(id) vim.fn.system("tmux kill-pane -t " .. id .. " 2>/dev/null") end,
  },
  -- kitty: add a ClaudePaneBackend table here and list it in backend_order
}
local backend_order = { "wezterm", "tmux" }

-- lazy init: defer external command calls until first use
local _initialized = false
---@type ClaudePaneBackend?
local backend
---@type string?
local nvim_pane

local function ensure_init()
  if _initialized then return end
  _initialized = true
  for _, name in ipairs(backend_order) do
    local b = backend_defs[name]
    if b.is_active() then
      backend = b
      nvim_pane = b.current_pane()
      break
    end
  end
end

--- Decide split direction from the pane's cols/rows (cell aspect-ratio 2.2x correction).
---@param target string  target pane id
---@return boolean horizontal
local function smart_horizontal(target)
  local cols, rows = backend.pane_size(target)
  return cols ~= nil and rows ~= nil and cols > rows * 2.2
end

--- Build the split-pane command. If env_table is given, inject env vars into the new pane.
---@param shell_cmd string  shell command to run in the new pane
---@param env_table table?  env var table {KEY=VAL,...}
---@return string[] cmd     argument list to pass to vim.fn.system / jobstart
local function build_split_cmd(shell_cmd, env_table)
  -- First call: split the nvim pane. After: split the most recently created claude pane.
  local target = pane_ids[#pane_ids] or nvim_pane
  local percent = pane_ids[#pane_ids] and "50" or "35"
  return backend.split_cmd(target, smart_horizontal(target), percent, env_table, shell_cmd)
end

local function kill_all()
  if not backend then return end
  for _, id in ipairs(pane_ids) do
    backend.kill(id)
  end
  pane_ids = {}
end

--- Run a standalone claude CLI in a new external pane (multiple allowed).
function M.open()
  ensure_init()
  if not backend or not nvim_pane then
    vim.notify("claude-pane: no supported terminal detected (wezterm/tmux)", vim.log.levels.WARN)
    return
  end
  local raw = vim.fn.system(build_split_cmd "claude")
  if vim.v.shell_error == 0 then
    table.insert(pane_ids, vim.trim(raw))
  end
end

--- claudecode.nvim external_terminal_cmd callback.
--- Takes the cmd_string and env_table from claudecode and returns the command to run in an external pane.
---@param cmd_string string  claude CLI command to run
---@param env_table table    MCP-connection env such as CLAUDE_CODE_SSE_PORT
---@return string[]?
function M.external_cmd(cmd_string, env_table)
  ensure_init()
  if not backend or not nvim_pane then
    vim.notify("claude-pane: no supported terminal detected (wezterm/tmux)", vim.log.levels.WARN)
    return nil
  end
  -- No way to track the pane id claudecode creates, so it's not added to pane_ids.
  -- (claudecode.nvim fires the split via jobstart; cleanup is left to the user / Vim exit)
  return build_split_cmd(cmd_string, env_table)
end

--- Whether external panes are usable (env check only — no external process calls).
---@return boolean
function M.is_available()
  for _, name in ipairs(backend_order) do
    if backend_defs[name].is_active() then return true end
  end
  return false
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = kill_all,
  desc = "claude-pane: clean up external panes",
})

function M.setup()
  if not M.is_available() then return end
  vim.keymap.set("n", "<Leader>ac", M.open, { desc = "Open Claude Code pane" })
end

return M
