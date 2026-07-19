-- Run the Claude CLI directly in an external terminal pane (wezterm > tmux).
-- claudecode.nvim's external provider reuses this module's pane-split logic.
-- Panes created here are auto-cleaned on nvim exit.
local platform = require "core.platform"

local M = {}

---@type string[]
local pane_ids = {}

-- lazy init: defer external command calls until first use
local _initialized = false
local wezterm_bin, backend, nvim_pane

local function ensure_init()
  if _initialized then return end
  _initialized = true

  wezterm_bin = (platform.is_wsl and vim.fn.executable("wezterm.exe") == 1) and "wezterm.exe" or "wezterm"

  if platform.in_wezterm then
    backend = "wezterm"
    if vim.env.WEZTERM_PANE then
      nvim_pane = vim.env.WEZTERM_PANE
    else
      -- WSL doesn't get WEZTERM_PANE; detect via the focused pane instead.
      -- (cli list's is_active reports one per tab, so it can pick a pane in another tab)
      local info = vim.fn.system(wezterm_bin .. " cli list-clients --format json 2>/dev/null")
      local ok, clients = pcall(vim.json.decode, info)
      if ok then
        local best
        for _, c in ipairs(clients) do
          if c.focused_pane_id and (not best or c.idle_time.secs < best.idle_time.secs) then best = c end
        end
        if best then nvim_pane = tostring(best.focused_pane_id) end
      end
    end
  elseif vim.env.TMUX then
    backend = "tmux"
    nvim_pane = vim.env.TMUX_PANE or vim.trim(vim.fn.system("tmux display-message -p '#{pane_id}'"))
  end
end

--- Decide split direction from the pane's cols/rows (cell aspect-ratio 2.2x correction).
---@param target string  target pane id
---@return string direction wezterm: "--right"|"--bottom", tmux: "-h"|"-v"
local function smart_dir(target)
  local cols, rows
  if backend == "wezterm" then
    local info = vim.fn.system(wezterm_bin .. " cli list --format json 2>/dev/null")
    local ok, panes = pcall(vim.json.decode, info)
    if ok then
      for _, p in ipairs(panes) do
        if tostring(p.pane_id) == tostring(target) then
          cols, rows = p.size.cols, p.size.rows
          break
        end
      end
    end
    if cols and rows and cols > rows * 2.2 then return "--right" end
    return "--bottom"
  else
    cols = tonumber(vim.fn.system("tmux display -p -t " .. target .. " '#{pane_width}'"))
    rows = tonumber(vim.fn.system("tmux display -p -t " .. target .. " '#{pane_height}'"))
    if cols and rows and cols > rows * 2.2 then return "-h" end
    return "-v"
  end
end

--- Build the split-pane command. If env_table is given, inject env vars into the new pane.
---@param shell_cmd string  shell command to run in the new pane
---@param env_table table?  env var table {KEY=VAL,...}
---@return string[] cmd     argument list to pass to vim.fn.system / jobstart
local function build_split_cmd(shell_cmd, env_table)
  -- First call: split the nvim pane. After: split the most recently created claude pane.
  local target = pane_ids[#pane_ids] or nvim_pane
  local percent = pane_ids[#pane_ids] and "50" or "35"
  local dir = smart_dir(target)
  if backend == "wezterm" then
    local cmd = { wezterm_bin, "cli", "split-pane", "--pane-id", tostring(target), dir, "--percent", percent }
    if env_table then
      for k, v in pairs(env_table) do
        table.insert(cmd, "--env")
        table.insert(cmd, k .. "=" .. v)
      end
    end
    vim.list_extend(cmd, { "--", platform.shell, "-lc", shell_cmd })
    return cmd
  else
    local cmd = { "tmux", "split-window", dir, "-l", percent .. "%", "-P", "-F", "#{pane_id}", "-t", target }
    if env_table then
      for k, v in pairs(env_table) do
        table.insert(cmd, "-e")
        table.insert(cmd, k .. "=" .. v)
      end
    end
    vim.list_extend(cmd, { platform.shell, "-lc", shell_cmd })
    return cmd
  end
end

local function kill_all()
  for _, id in ipairs(pane_ids) do
    if backend == "wezterm" then
      vim.fn.system(wezterm_bin .. " cli kill-pane --pane-id " .. id)
    else
      vim.fn.system("tmux kill-pane -t " .. id .. " 2>/dev/null")
    end
  end
  pane_ids = {}
end

--- Run a standalone claude CLI in a new external pane (multiple allowed).
function M.open()
  ensure_init()
  if not backend then
    vim.notify("claude-pane: wezterm/tmux 환경이 아닙니다", vim.log.levels.WARN)
    return
  end
  local raw = vim.fn.system(build_split_cmd("claude"))
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
  if not backend then
    vim.notify("claude-pane: wezterm/tmux 환경이 아닙니다", vim.log.levels.WARN)
    return nil
  end
  -- No way to track the pane id claudecode creates, so it's not added to pane_ids.
  -- (claudecode.nvim fires the wezterm cli call via jobstart; cleanup is left to the user / Vim exit)
  return build_split_cmd(cmd_string, env_table)
end

--- Whether external panes are usable (env check only — no external process calls).
---@return boolean
function M.is_available() return platform.in_wezterm or platform.in_tmux end

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = kill_all,
  desc = "claude-pane: 외부 pane 정리",
})

function M.setup()
  if not M.is_available() then return end
  vim.keymap.set("n", "<Leader>ac", M.open, { desc = "Open Claude Code pane" })
end

return M
