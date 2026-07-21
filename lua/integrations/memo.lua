if vim.env.NVIM_MEMO ~= "1" then
  return
end

local memo_dir = (vim.env.XDG_DATA_HOME or vim.fn.expand "~/.local/share") .. "/memo"
vim.fn.mkdir(memo_dir, "p")

local group = vim.api.nvim_create_augroup("memo_mode", {})

vim.o.autowriteall = true
-- The title is what open-memo.ps1's AppActivate matches to focus this window.
vim.o.title = true
vim.o.titlestring = "memo-pad"

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  nested = true,
  callback = function()
    if vim.fn.argc() == 0 then
      require("persistence").load()
    end
    -- Session load wipes the buffer list, so files sent over the socket
    -- before this point would be lost; listen only from here on.
    local sock = vim.fn.stdpath "cache" .. "/memo.sock"
    os.remove(sock)
    vim.fn.serverstart(sock)
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
  adopt_unnamed()
  save_timer:start(
    1000,
    0,
    vim.schedule_wrap(function()
      vim.cmd "silent! wall"
    end)
  )
end

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost", "BufLeave" }, {
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
