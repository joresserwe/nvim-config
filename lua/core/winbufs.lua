-- Per-window buffer list: bind buffers to a pane (window), like IDEA's split view.
local M = {}

local function trackable(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.bo[buf].buftype == ""
end

local function set_list(win, bufs)
  vim.w[win].winbufs = bufs
  vim.w[win].winbufs_owner = win
end

--- A window's buffer list. w: vars are copied from the source window on split,
--- so if the owner isn't the current window, reinit to just the displayed buffer.
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

--- For the bufferline filter: windows without a list (neo-tree, dashboard, etc.) fall back to the global list.
function M.contains(buf, win)
  local bufs = M.list(win)
  if #bufs == 0 then return not vim.t.bufs or vim.tbl_contains(vim.t.bufs, buf) end
  return vim.tbl_contains(bufs, buf)
end

--- Whether another window is displaying buf or holds it in its list.
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

--- Remove the current buffer from this window's list only. If the list empties, close the window;
--- delete the buffer only when it remains in no window.
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

  -- Closed the last buffer in the last window: go to the dashboard.
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
    -- Seed the list right after a split, before the buffer changes.
    M.add(vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf())
    vim.cmd.redrawtabline()
  end,
})

return M
