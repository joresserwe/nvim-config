local function augroup(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

local function is_valid(bufnr)
  if not bufnr then bufnr = 0 end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

-- Fire `User Astro<pattern>` — keep the Astro prefix so existing consumer specs' event names still match.
local function emit(pattern, instant)
  local event = { pattern = "Astro" .. pattern, modeline = false }
  if instant then
    vim.api.nvim_exec_autocmds("User", event)
  else
    vim.schedule(function() vim.api.nvim_exec_autocmds("User", event) end)
  end
end

local current_buf, last_buf

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup "auto_quit",
  desc = "Quit if only sidebar windows are left",
  callback = function()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    if #wins == 1 then return end
    local sidebar_fts = { ["neo-tree"] = true }
    for _, winid in ipairs(wins) do
      if vim.api.nvim_win_is_valid(winid) then
        local filetype = vim.bo[vim.api.nvim_win_get_buf(winid)].filetype
        if not sidebar_fts[filetype] then
          return
        else
          sidebar_fts[filetype] = nil
        end
      end
    end
    if #vim.api.nvim_list_tabpages() > 1 then
      vim.cmd.tabclose()
    else
      vim.cmd.qall()
    end
  end,
})

local bufferline_group = augroup "bufferline"
vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter", "TabNewEntered" }, {
  group = bufferline_group,
  desc = "Update buffers when adding new buffers",
  callback = function(args)
    if not vim.t.bufs then vim.t.bufs = {} end
    if not is_valid(args.buf) then return end
    if args.buf ~= current_buf then
      last_buf = is_valid(current_buf) and current_buf or nil
      current_buf = args.buf
    end
    local bufs = vim.t.bufs
    if not vim.tbl_contains(bufs, args.buf) then
      table.insert(bufs, args.buf)
      vim.t.bufs = bufs
    end
    vim.t.bufs = vim.tbl_filter(is_valid, vim.t.bufs)
    emit "BufsUpdated"
  end,
})
vim.api.nvim_create_autocmd({ "BufDelete", "TermClose" }, {
  group = bufferline_group,
  desc = "Update buffers when deleting buffers",
  callback = function(args)
    local removed
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      local bufs = vim.t[tab].bufs
      if bufs then
        for i, bufnr in ipairs(bufs) do
          if bufnr == args.buf then
            removed = true
            table.remove(bufs, i)
            vim.t[tab].bufs = bufs
            break
          end
        end
      end
    end
    vim.t.bufs = vim.tbl_filter(is_valid, vim.t.bufs)
    if removed then emit "BufsUpdated" end
    vim.cmd.redrawtabline()
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup "checktime",
  desc = "Check if buffers changed on editor focus",
  callback = function()
    if vim.bo.buftype ~= "nofile" then vim.cmd "checktime" end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup "create_dir",
  desc = "Automatically create parent directories if they don't exist when saving a file",
  callback = function(args)
    local file = args.match
    if not is_valid(args.buf) or file:match "^%w+:[\\/][\\/]" then return end
    vim.fn.mkdir(vim.fs.abspath(vim.fs.dirname(vim.uv.fs_realpath(file) or file)), "p")
  end,
})

local function git_tracked(folder)
  local cmd = { "git", "-C", folder, "rev-parse" }
  if vim.fn.has "win32" == 1 then cmd = vim.list_extend({ "cmd.exe", "/C" }, cmd) end
  vim.fn.system(cmd)
  return vim.v.shell_error == 0
end
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost" }, {
  group = augroup "file_user_events",
  desc = "User events for file detection (AstroFile and AstroGitFile)",
  callback = function(args)
    if vim.b[args.buf].astrofile_checked then return end
    vim.b[args.buf].astrofile_checked = true
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then return end
      local current_file = vim.api.nvim_buf_get_name(args.buf)
      if vim.g.vscode or not (current_file == "" or vim.bo[args.buf].buftype == "nofile") then
        local skip_augroups = {}
        for _, autocmd in ipairs(vim.api.nvim_get_autocmds { event = args.event }) do
          if autocmd.group_name then skip_augroups[autocmd.group_name] = true end
        end
        skip_augroups["filetypedetect"] = false
        vim.api.nvim_exec_autocmds("User", { pattern = "AstroFile", modeline = false })
        local folder = vim.fs.abspath(vim.fs.dirname(current_file))
        if vim.fn.has "win32" == 1 then folder = ('"%s"'):format(folder) end
        if vim.fn.executable "git" == 1 then
          if git_tracked(folder) then
            vim.api.nvim_exec_autocmds("User", { pattern = "AstroGitFile", modeline = false })
            pcall(vim.api.nvim_del_augroup_by_name, "file_user_events")
          end
        else
          pcall(vim.api.nvim_del_augroup_by_name, "file_user_events")
        end
        vim.schedule(function()
          if is_valid(args.buf) then
            for _, autocmd in ipairs(vim.api.nvim_get_autocmds { event = args.event }) do
              if autocmd.group_name and not skip_augroups[autocmd.group_name] then
                vim.api.nvim_exec_autocmds(
                  args.event,
                  { group = autocmd.group_name, buffer = args.buf, data = args.data }
                )
                skip_augroups[autocmd.group_name] = true
              end
            end
          end
        end)
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup "highlightyank",
  desc = "Highlight yanked text",
  pattern = "*",
  callback = function() vim.hl.on_yank() end,
})

local large_buf_opts = { size = 1024 * 256, lines = 10000, line_length = 1000 }
local function is_large(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_loaded(bufnr) or not is_valid(bufnr) then return false end
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  local file_size = ok and stats and stats.size or 0
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local too_large = file_size > large_buf_opts.size
  local too_long = line_count > large_buf_opts.lines
  local too_wide = (file_size / line_count) - 1 > large_buf_opts.line_length
  return too_large or too_long or too_wide or false
end
vim.api.nvim_create_autocmd("BufRead", {
  group = augroup "large_buf_detector",
  desc = "Large buffer detection loading a file into a buffer",
  callback = function(args)
    if is_large(args.buf) then
      vim.b[args.buf].large_buf = true
      vim.notify(
        ("Large file detected `%s`\nSome Neovim features may be disabled"):format(
          vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ":p:~:.")
        )
      )
      emit("LargeBuf", true)
    end
  end,
})
vim.api.nvim_create_autocmd("User", {
  group = augroup "large_buf_settings",
  desc = "Disable certain functionality on very large files",
  pattern = "AstroLargeBuf",
  callback = function(args)
    vim.opt_local.list = false
    vim.b[args.buf].autoformat = false
    vim.b[args.buf].completion = false
  end,
})

local q_close_group = augroup "q_close_windows"
local q_mapped = {}
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = q_close_group,
  desc = "Make q close help, man, quickfix, dap floats",
  callback = function(args)
    if q_mapped[args.buf] then return end
    q_mapped[args.buf] = true
    for _, map in ipairs(vim.api.nvim_buf_get_keymap(args.buf, "n")) do
      if map.lhs == "q" then return end
    end
    if vim.tbl_contains({ "help", "nofile", "quickfix" }, vim.bo[args.buf].buftype) then
      vim.keymap.set("n", "q", "<Cmd>close<CR>", {
        desc = "Close window",
        buffer = args.buf,
        silent = true,
        nowait = true,
      })
    end
  end,
})
vim.api.nvim_create_autocmd("BufDelete", {
  group = q_close_group,
  desc = "Clean up q_close_windows cache",
  callback = function(args) q_mapped[args.buf] = nil end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup "restore_cursor",
  desc = "Restore last cursor position when opening a file",
  callback = function(args)
    local buf = args.buf
    if vim.b[buf].last_loc_restored or vim.tbl_contains({ "gitcommit" }, vim.bo[buf].filetype) then return end
    vim.b[buf].last_loc_restored = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup "unlist_quickfix",
  desc = "Unlist quickfix buffers",
  pattern = "qf",
  callback = function() vim.opt_local.buflisted = false end,
})

local mid_mapping = false
vim.on_key(function(char)
  if mid_mapping then return end
  local new_hlsearch
  local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
  if mode == "n" then
    new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
  elseif mode == "r" then
    new_hlsearch = true
  elseif mode == "c" and vim.tbl_contains({ "<CR>" }, vim.fn.keytrans(char)) then
    local cmd = vim.fn.getcmdline()
    if (cmd:match "^s" or cmd:match "^%%s" or cmd:match "^'<,'>s") and vim.o.incsearch then
      new_hlsearch = true
    end
  else
    return
  end
  if vim.o.hlsearch ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
  mid_mapping = true
  vim.schedule(function() mid_mapping = false end)
end)
