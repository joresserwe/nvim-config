-- 창별 버퍼 목록: IDEA 분할창처럼 buffer를 pane(window)에 종속시킨다
local M = {}

local function trackable(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype == ""
end

local function set_list(win, bufs)
  vim.w[win].winbufs = bufs
  vim.w[win].winbufs_owner = win
end

--- 창의 버퍼 목록. w: 변수는 분할 시 원본 창에서 복사되므로
--- owner가 현재 창이 아니면 표시 중인 버퍼 하나로 초기화한다
function M.list(win)
  win = win or vim.api.nvim_get_current_win()
  if vim.w[win].winbufs_owner ~= win then
    local buf = vim.api.nvim_win_get_buf(win)
    set_list(win, trackable(buf) and { buf } or {})
  end
  return vim.w[win].winbufs
end

function M.add(win, buf)
  if not trackable(buf) then return end
  local bufs = M.list(win)
  if not vim.tbl_contains(bufs, buf) then
    table.insert(bufs, buf)
    set_list(win, bufs)
  end
end

--- bufferline 필터용: 목록이 없는 창(neo-tree, 대시보드 등)은 전역 목록으로 폴백
function M.contains(buf, win)
  local bufs = M.list(win)
  if #bufs == 0 then return not vim.t.bufs or vim.tbl_contains(vim.t.bufs, buf) end
  return vim.tbl_contains(bufs, buf)
end

--- 다른 창이 buf를 표시 중이거나 목록에 갖고 있는지
local function referenced(buf, skip_win)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= skip_win and vim.api.nvim_win_get_buf(win) == buf then return true end
    if vim.w[win].winbufs_owner == win and vim.tbl_contains(vim.w[win].winbufs, buf) then return true end
  end
  return false
end

local function delete_buf(buf)
  if vim.bo[buf].modified then
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
    local choice = vim.fn.confirm(('"%s" 변경사항을 저장할까요?'):format(name), "&Yes\n&No\n&Cancel")
    if choice == 1 then
      vim.api.nvim_buf_call(buf, function() vim.cmd.write() end)
    elseif choice ~= 2 then
      return
    end
  end
  pcall(vim.api.nvim_buf_delete, buf, { force = true })
end

--- 현재 버퍼를 이 창의 목록에서만 제거. 목록이 비면 창을 닫고,
--- 버퍼 삭제는 어느 창에도 남지 않았을 때만 수행한다
function M.close()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)

  if not trackable(buf) then
    if not pcall(vim.api.nvim_win_close, win, false) then pcall(vim.api.nvim_buf_delete, buf, {}) end
    return
  end

  local rest = vim.tbl_filter(function(b) return b ~= buf and trackable(b) end, M.list(win))
  set_list(win, rest)

  local closed = false
  if #rest > 0 then
    vim.api.nvim_win_set_buf(win, rest[#rest])
  else
    closed = pcall(vim.api.nvim_win_close, win, false)
  end

  if not referenced(buf, win) then delete_buf(buf) end

  -- 마지막 창에서 마지막 버퍼를 닫았으면 대시보드로
  if not closed and #rest == 0 and vim.api.nvim_win_is_valid(win) then
    local cur = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_name(cur) == "" and not vim.bo[cur].modified then
      pcall(function() require("snacks").dashboard() end)
    end
  end
end

local group = vim.api.nvim_create_augroup("winbufs", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(ev) M.add(vim.api.nvim_get_current_win(), ev.buf) end,
})
vim.api.nvim_create_autocmd("WinEnter", {
  group = group,
  callback = function()
    -- 분할 직후 버퍼를 바꾸기 전에 목록을 초기화해 둔다
    M.add(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf())
    vim.cmd.redrawtabline()
  end,
})

return M
