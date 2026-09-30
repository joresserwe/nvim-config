local M = {}
local platform = require "core.platform"

local function copy(value, label)
  vim.fn.setreg("+", value, "v")
  vim.notify(label .. " 복사 완료")
end

local function file_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or vim.bo.buftype ~= "" then
    vim.notify("파일명이 있는 일반 버퍼에서 사용할 수 있습니다", vim.log.levels.WARN)
    return
  end
  return path
end

function M.filename()
  local path = file_path()
  if path then copy(vim.fn.fnamemodify(path, ":t"), "파일명") end
end

function M.relative_path()
  local path = file_path()
  if path then copy(vim.fn.fnamemodify(path, ":."), "상대 경로") end
end

function M.absolute_path()
  local path = file_path()
  if path then copy(path, "절대 경로") end
end

function M.windows_path()
  local path = file_path()
  if not path then return end
  if platform.is_windows then
    copy(path, "Windows 절대 경로")
    return
  end
  if not platform.is_wsl or not platform.has_exec "wslpath" then
    vim.notify("Windows 경로 변환에는 WSL의 wslpath가 필요합니다", vim.log.levels.WARN)
    return
  end
  local value = vim.fn.system { "wslpath", "-w", path }
  if vim.v.shell_error ~= 0 then
    vim.notify("Windows 경로 변환 실패: " .. vim.trim(value), vim.log.levels.ERROR)
    return
  end
  copy((value:gsub("\r?\n$", "")), "Windows 절대 경로")
end

function M.contents()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local value = table.concat(lines, "\n")
  if vim.bo.endofline and not (#lines == 1 and lines[1] == "") then value = value .. "\n" end
  copy(value, "전체 내용")
end

return M
