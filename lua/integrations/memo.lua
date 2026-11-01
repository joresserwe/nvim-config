if vim.env.NVIM_MEMO ~= "1" then
  return
end
vim.env.NVIM_MEMO = nil

local memo_dir = (vim.env.XDG_DATA_HOME or vim.fn.expand "~/.local/share") .. "/memo"
vim.fn.mkdir(memo_dir, "p")

local group = vim.api.nvim_create_augroup("memo_mode", {})

vim.o.autowriteall = true
-- The title is what open-memo.ps1's AppActivate matches to focus this window.
vim.o.title = true
vim.o.titlestring = "memo-pad"
vim.opt.sessionoptions:remove { "blank", "help", "terminal" }

local session_file

local function save_session()
  if not session_file then
    return
  end
  local tmp = session_file .. ".tmp"
  if pcall(vim.cmd, "mksession! " .. vim.fn.fnameescape(tmp)) then
    os.rename(tmp, session_file)
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  nested = true,
  callback = function()
    local files = vim.tbl_map(function(f)
      return vim.fn.fnamemodify(f, ":p")
    end, vim.fn.argv())
    local persistence = require "persistence"
    local file = persistence.current()
    persistence.stop()
    if vim.fn.filereadable(file) == 1 then
      vim.cmd("silent! source " .. vim.fn.fnameescape(file))
    end
    for _, f in ipairs(files) do
      vim.cmd("edit " .. vim.fn.fnameescape(f))
    end
    session_file = file
    save_session()
    -- Session load wipes the buffer list, so files sent over the socket
    -- before this point would be lost; listen only from here on.
    local sock = vim.fn.stdpath "cache" .. "/memo.sock"
    os.remove(sock)
    vim.fn.serverstart(sock)
  end,
})

local function is_running_nvim(pid)
  local f = pid > 0 and io.open(("/proc/%d/comm"):format(pid))
  if not f then
    return false
  end
  local comm = f:read "*l"
  f:close()
  return comm == "nvim"
end

-- On SIGHUP (terminal window closed) nvim drops its memlines before
-- VimLeavePre, so writes there fail with E749 and edits newer than the last
-- autosave survive only in the swap file.
vim.api.nvim_create_autocmd("SwapExists", {
  group = group,
  callback = function(args)
    local swap = vim.v.swapname
    local info = vim.fn.swapinfo(swap)
    if is_running_nvim(tonumber(info.pid) or 0) then
      vim.v.swapchoice = "o"
      return
    end
    local file_stat, swap_stat = vim.uv.fs_stat(args.match), vim.uv.fs_stat(swap)
    if info.dirty ~= 1 or (file_stat and swap_stat and file_stat.mtime.sec > swap_stat.mtime.sec) then
      vim.v.swapchoice = "d"
      return
    end
    vim.v.swapchoice = "r"
    vim.schedule(function()
      vim.fn.delete(swap)
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.api.nvim_buf_call(args.buf, function()
          vim.cmd "silent! write"
        end)
      end
    end)
  end,
})

local function next_memo_file()
  local i = 1
  while vim.uv.fs_stat(("%s/new-%d.md"):format(memo_dir, i)) do
    i = i + 1
  end
  return ("%s/new-%d.md"):format(memo_dir, i)
end

local function adopt_unnamed()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_loaded(buf)
      and vim.bo[buf].buftype == ""
      and vim.api.nvim_buf_get_name(buf) == ""
      and vim.bo[buf].modified
    then
      vim.api.nvim_buf_set_name(buf, next_memo_file())
      vim.api.nvim_buf_call(buf, function()
        vim.cmd "silent! write"
        vim.cmd "silent! edit"
      end)
    end
  end
end

local save_timer = assert(vim.uv.new_timer())
local function autosave()
  save_timer:start(
    1000,
    0,
    vim.schedule_wrap(function()
      adopt_unnamed()
      vim.cmd "silent! wall"
      save_session()
    end)
  )
end

vim.api.nvim_create_autocmd({
  "InsertLeave",
  "TextChanged",
  "TextChangedI",
  "FocusLost",
  "BufLeave",
  "BufAdd",
  "BufDelete",
  "WinClosed",
  "TabClosed",
}, {
  group = group,
  callback = autosave,
})

-- :q/:qa checks modified buffers (and prompts) before VimLeavePre fires;
-- adoption must precede that check.
vim.api.nvim_create_autocmd({ "QuitPre", "ExitPre" }, {
  group = group,
  callback = function()
    adopt_unnamed()
    vim.cmd "silent! wall"
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = group,
  callback = save_session,
})
