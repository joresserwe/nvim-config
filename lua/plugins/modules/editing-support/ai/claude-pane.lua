-- 외부 터미널 pane에서 Claude CLI 직접 실행 (wezterm > tmux)
-- claudecode.nvim의 external provider도 이 모듈을 통해 동일한 pane 분할 로직을 재사용한다.
-- nvim 종료 시 생성된 pane을 자동으로 정리한다.
local platform = require "core.platform"

local M = {}

---@type string[]
local pane_ids = {}

-- lazy init: 첫 사용 시점까지 외부 명령 호출을 지연
local _initialized = false
local wezterm_bin, backend, nvim_pane

local function ensure_init()
  if _initialized then return end
  _initialized = true

  wezterm_bin = (platform.is_wsl and vim.fn.executable("wezterm.exe") == 1) and "wezterm.exe" or "wezterm"

  if platform.in_wezterm then
    backend = "wezterm"
    -- wezterm pane id 감지
    if vim.env.WEZTERM_PANE then
      nvim_pane = vim.env.WEZTERM_PANE
    else
      -- WSL에는 WEZTERM_PANE이 전달되지 않음 → 포커스된 pane으로 감지
      -- (cli list의 is_active는 탭마다 하나씩 있어 다른 탭 pane이 잡힐 수 있음)
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

--- 주어진 pane의 cols/rows를 구해 분할 방향 결정 (셀 종횡비 2.2x 보정)
---@param target string  대상 pane id
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

--- split-pane 명령어 빌드. env_table이 주어지면 새 pane에 환경변수 주입.
---@param shell_cmd string  새 pane에서 실행할 셸 커맨드
---@param env_table table?  환경변수 테이블 {KEY=VAL,...}
---@return string[] cmd     vim.fn.system / jobstart에 넘길 인자 리스트
local function build_split_cmd(shell_cmd, env_table)
  -- 첫 호출: nvim pane을 분할. 이후: 마지막으로 만든 claude pane을 다시 분할.
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
    table.insert(cmd, shell_cmd)
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

--- 새 외부 pane에 standalone claude CLI 실행 (복수 가능)
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

--- claudecode.nvim external_terminal_cmd 콜백.
--- claudecode가 부여한 cmd_string과 env_table을 받아 외부 pane에서 실행할 명령을 리턴.
---@param cmd_string string  실행할 claude CLI 커맨드
---@param env_table table    CLAUDE_CODE_SSE_PORT 등 MCP 연결용 env
---@return string[]?
function M.external_cmd(cmd_string, env_table)
  ensure_init()
  if not backend then
    vim.notify("claude-pane: wezterm/tmux 환경이 아닙니다", vim.log.levels.WARN)
    return nil
  end
  -- claudecode가 만든 pane id를 추적할 방법이 없으므로 pane_ids에는 넣지 않는다.
  -- (claudecode.nvim이 jobstart로 wezterm cli 호출을 끝내면 정리는 사용자/Vim 종료에 맡김)
  return build_split_cmd(cmd_string, env_table)
end

--- 외부 pane 사용 가능 여부 (env 판정만 — 외부 프로세스 호출 없음)
---@return boolean
function M.is_available() return platform.in_wezterm or platform.in_tmux end

-- nvim 종료 시 standalone pane 자동 정리
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = kill_all,
  desc = "claude-pane: 외부 pane 정리",
})

function M.setup()
  if not M.is_available() then return end
  vim.keymap.set("n", "<Leader>ac", M.open, { desc = "Open Claude Code pane" })
end

return M
