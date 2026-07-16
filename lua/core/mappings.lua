-- 순수 편집 매핑 (플러그인 무관). polish.lua에서 로드 — lazy 셋업 이후 실행되어 기본값보다 항상 우선한다.
local map = vim.keymap.set
local winbufs = require "core.winbufs"

-- 레지스터 규율: y→i(inner), d→d(del), Y/·s 계열→시스템 클립보드, x/c→블랙홀
map("", "x", '"_x')
map("", "c", '"_c')
map("", "y", '"iy', { desc = "yank (inner reg)" })
map("", "Y", '"+y', { desc = "yank (system clipboard)" })
map("", "d", '"dd', { desc = "delete (del reg)" })
map("", "ps", '"+p', { desc = "paste from system clipboard" })
map("", "pi", '"ip', { desc = "paste from inner clipboard ('k')" })
map("", "pd", '"dp', { desc = "paste from deleted" })
map("", "Ps", '"+P', { desc = "paste from system clipboard" })
map("", "Pi", '"iP', { desc = "paste from inner clipboard ('k')" })
map("", "Pd", '"dP', { desc = "paste from deleted" })
map("n", "yy", '"iyy')
map("n", "Yy", '"+yy')
map("n", "YY", '"+yy')
map("n", "dd", '"ddd')
map("n", "p", "<Nop>")
map("n", "P", "<Nop>")
map("", "s", "<Nop>")

map("n", "<Leader>c", '"_ciw', { desc = "단어 편집" })
map("n", "<Leader>x", "viwx", { remap = true, desc = "단어 제거 (inner reg)" })
map("n", "<Leader>d", "viwd", { remap = true, desc = "단어 제거 (del reg)" })
map("n", "<Leader>pi", 'viw"_x"iP', { desc = "paste from inner clipboard('i')" })
map("n", "<Leader>pd", 'viw"_x"dP', { desc = "paste from deleted" })
map("n", "<Leader>ps", 'viw"_xP', { desc = "paste from system clipboard" })

map("", "(", "7k", { desc = "7줄 위로" })
map("", ")", "7j", { desc = "7줄 아래로" })
map("n", "<C-a>", "gg<S-v>G", { desc = "전체 선택" })
map("n", "<S-h>", "h", { desc = "오타 방지" })
map("n", "<S-l>", "l", { desc = "오타 방지" })
map("n", "<Leader>o", "o<ESC>", { desc = "아래로 한줄 띄기" })
map("n", "<Leader>O", "O<ESC>", { desc = "위로 한줄 띄기" })
map("n", "<Leader><CR>", "i<CR><ESC>k", { desc = "현재 커서 위치에서 줄바꿈" })

-- Prevent conflict <C-i> and <Tab>
map("n", "<C-p>", "<C-o>", { desc = "Jumplist back" })
map("n", "<C-n>", "<C-i>", { desc = "Jumplist forward" })
map("n", "<C-o>", "<Nop>", { desc = "Disabled (use <C-p>)" })

map("n", "<Leader>\\", "<C-w>v", { desc = "세로 분할" })
map("n", "<Leader>-", "<C-w>s", { desc = "가로 분할" })
map("n", "<Leader>=", "<C-w>x", { desc = "분할창 순서 변경" })
map("n", "<Leader>w", winbufs.close, { desc = "현재 창의 버퍼 닫기 (pane 단위)" })
map("n", "<Leader>m", function()
  local cur = vim.api.nvim_get_current_win()
  if vim.g.maximised_win == cur then
    vim.cmd "wincmd ="
    vim.g.maximised_win = nil
  else
    vim.cmd "wincmd _ | wincmd |"
    vim.g.maximised_win = cur
  end
end, { desc = "Maximize/equalize window" })

map("x", "J", ":move '>+1<CR>gv-gv", { desc = "한줄 아래로 내림" })
map("x", "K", ":move '<-2<CR>gv-gv", { desc = "한줄 위로 올림" })
map("x", "<", "<gv")
map("x", ">", ">gv")
map("x", "mf", "<C-v>^<S-i>", { desc = "Block insert (앞)" })
map("x", "mb", "<C-v>$<S-a>", { desc = "Block append (뒤)" })

map("t", "<C-w>", [[<C-\><C-n><C-w>]], { remap = true, desc = "창 명령" })

-- Plugin Manager (<Leader>')
map("n", "<Leader>'i", function() require("lazy").install() end, { desc = "Plugins Install" })
map("n", "<Leader>'s", function() require("lazy").home() end, { desc = "Plugins Status" })
map("n", "<Leader>'S", function() require("lazy").sync() end, { desc = "Plugins Sync" })
map("n", "<Leader>'u", function() require("lazy").check() end, { desc = "Plugins Check Updates" })
map("n", "<Leader>'U", function() require("lazy").update() end, { desc = "Plugins Update" })
map("n", "<Leader>'m", function() require("mason.ui").open() end, { desc = "Mason Installer" })
map("n", "<Leader>'M", "<Cmd>MasonToolsUpdate<CR>", { desc = "Mason Update" })
map("n", "<Leader>'a", function()
  require("lazy").update()
  vim.cmd "MasonToolsUpdate"
end, { desc = "Update Lazy and Mason" })

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Move cursor down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move cursor up" })
map("n", "<Leader>q", "<Cmd>confirm q<CR>", { desc = "Quit Window" })
map("n", "<Leader>Q", "<Cmd>confirm qall<CR>", { desc = "Exit Neovim" })
map("n", "<Leader>n", "<Cmd>enew<CR>", { desc = "New File" })
map("n", "<C-S>", "<Cmd>silent! update! | redraw<CR>", { desc = "Force write" })
map("n", "<C-Q>", "<Cmd>q!<CR>", { desc = "Force quit" })
map("n", "<Leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
map("x", "<Leader>/", "gc", { remap = true, desc = "Toggle comment" })
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
map("n", "<Leader>R", function() require("snacks").rename.rename_file() end, { desc = "Rename file" })
map("v", "<Tab>", ">gv", { desc = "Indent line" })
map("v", "<S-Tab>", "<gv", { desc = "Unindent line" })
map("n", "]t", function() vim.cmd.tabnext() end, { desc = "Next tab" })
map("n", "[t", function() vim.cmd.tabprevious() end, { desc = "Previous tab" })

-- 진단
map("n", "<Leader>li", function() vim.cmd.checkhealth "vim.lsp" end, { desc = "Lsp Information" })
map("n", "<Leader>ld", function() vim.diagnostic.open_float() end, { desc = "Hover diagnostics" })
map("n", "gl", function() vim.diagnostic.open_float() end, { desc = "Hover diagnostics" })
local function diagnostic_jump(dir, severity)
  return function()
    vim.diagnostic.jump { count = dir and vim.v.count1 or -vim.v.count1, severity = vim.diagnostic.severity[severity] }
  end
end
map("n", "[e", diagnostic_jump(false, "ERROR"), { desc = "Previous error" })
map("n", "]e", diagnostic_jump(true, "ERROR"), { desc = "Next error" })
map("n", "[w", diagnostic_jump(false, "WARN"), { desc = "Previous warning" })
map("n", "]w", diagnostic_jump(true, "WARN"), { desc = "Next warning" })

-- 버퍼 (bufferline 명령 기반)
map("n", "]b", function() require("bufferline").cycle(vim.v.count1) end, { desc = "Next buffer" })
map("n", "[b", function() require("bufferline").cycle(-vim.v.count1) end, { desc = "Previous buffer" })
map("n", ">b", function() require("bufferline").move(vim.v.count1) end, { desc = "Move buffer tab right" })
map("n", "<b", function() require("bufferline").move(-vim.v.count1) end, { desc = "Move buffer tab left" })
map("n", "<Leader>bp", "<Cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
map("n", "<Leader>bc", "<Cmd>BufferLineCloseOthers<CR>", { desc = "Close all buffers except current" })
map("n", "<Leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Close all buffers to the left" })
map("n", "<Leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Close all buffers to the right" })
map("n", "<Leader>bse", "<Cmd>BufferLineSortByExtension<CR>", { desc = "By extension" })
map("n", "<Leader>bsp", "<Cmd>BufferLineSortByDirectory<CR>", { desc = "By directory" })
map("n", "<Leader>bsr", "<Cmd>BufferLineSortByRelativeDirectory<CR>", { desc = "By relative directory" })

-- 터미널 창 이동
local function term_nav(dir)
  return function()
    if vim.api.nvim_win_get_config(0).zindex then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-" .. dir .. ">", true, false, true), "n", false)
    else
      vim.cmd.wincmd(dir)
    end
  end
end
map("t", "<C-H>", term_nav "h", { desc = "Terminal left window navigation" })
map("t", "<C-J>", term_nav "j", { desc = "Terminal down window navigation" })
map("t", "<C-K>", term_nav "k", { desc = "Terminal up window navigation" })
map("t", "<C-L>", term_nav "l", { desc = "Terminal right window navigation" })

-- UI/UX 토글 (<Leader>u*)
map("n", "<Leader>ub", function()
  vim.go.background = vim.go.background == "light" and "dark" or "light"
  vim.notify(("background=%s"):format(vim.go.background))
end, { desc = "Toggle background" })
map("n", "<Leader>ud", function() require("snacks").toggle.diagnostics():toggle() end, { desc = "Toggle diagnostics" })
map("n", "<Leader>us", function() require("snacks").toggle.option("spell"):toggle() end, { desc = "Toggle spellcheck" })
map("n", "<Leader>uw", function() require("snacks").toggle.option("wrap"):toggle() end, { desc = "Toggle wrap" })
map(
  "n",
  "<Leader>uS",
  function() require("snacks").toggle.option("conceallevel", { on = 2, off = 0 }):toggle() end,
  { desc = "Toggle conceal" }
)
map(
  "n",
  "<Leader>ut",
  function() require("snacks").toggle.option("showtabline", { on = 2, off = 0, global = true }):toggle() end,
  { desc = "Toggle tabline" }
)
map("n", "<Leader>ug", function()
  if vim.wo.signcolumn == "no" then
    vim.wo.signcolumn = "yes"
  elseif vim.wo.signcolumn == "yes" then
    vim.wo.signcolumn = "auto"
  else
    vim.wo.signcolumn = "no"
  end
  vim.notify(("signcolumn=%s"):format(vim.wo.signcolumn))
end, { desc = "Toggle signcolumn" })
local last_active_foldcolumn
map("n", "<Leader>u>", function()
  local curr_foldcolumn = vim.wo.foldcolumn
  if curr_foldcolumn ~= "0" then last_active_foldcolumn = curr_foldcolumn end
  vim.wo.foldcolumn = curr_foldcolumn == "0" and (last_active_foldcolumn or "1") or "0"
  vim.notify(("foldcolumn=%s"):format(vim.wo.foldcolumn))
end, { desc = "Toggle foldcolumn" })
map("n", "<Leader>ui", function()
  local input_avail, input = pcall(vim.fn.input, "Set indent value (>0 expandtab, <=0 noexpandtab): ")
  if input_avail then
    local indent = tonumber(input)
    if not indent or indent == 0 then return end
    vim.bo.expandtab = (indent > 0)
    indent = math.abs(indent)
    vim.bo.tabstop = indent
    vim.bo.softtabstop = indent
    vim.bo.shiftwidth = indent
    vim.notify(("indent=%d %s"):format(indent, vim.bo.expandtab and "expandtab" or "noexpandtab"))
  end
end, { desc = "Change indent setting" })
map("n", "<Leader>ul", function()
  local laststatus, status = vim.opt.laststatus:get(), nil
  if laststatus == 0 then
    vim.opt.laststatus, status = 2, "local"
  elseif laststatus == 2 then
    vim.opt.laststatus, status = 3, "global"
  else
    vim.opt.laststatus, status = 0, "off"
  end
  vim.notify(("statusline %s"):format(status))
end, { desc = "Toggle statusline" })
map("n", "<Leader>un", function()
  local number, relativenumber = vim.wo.number, vim.wo.relativenumber
  if not number and not relativenumber then
    vim.wo.number = true
  elseif number and not relativenumber then
    vim.wo.relativenumber = true
  elseif number and relativenumber then
    vim.wo.number = false
  else
    vim.wo.relativenumber = false
  end
  vim.notify(
    ("number %s, relativenumber %s"):format(vim.wo.number and "on" or "off", vim.wo.relativenumber and "on" or "off")
  )
end, { desc = "Change line numbering" })
local notifications_off, saved_notify = false, nil
map("n", "<Leader>uN", function()
  notifications_off = not notifications_off
  if notifications_off then
    saved_notify = vim.notify
    vim.notify = function() end
  else
    vim.notify = saved_notify
    vim.notify "Notifications on"
  end
end, { desc = "Toggle Notifications" })
local previous_virtual_text
map("n", "<Leader>uv", function()
  local virtual_text = vim.diagnostic.config().virtual_text
  local new_virtual_text = false
  if virtual_text then
    previous_virtual_text = virtual_text
  else
    new_virtual_text = previous_virtual_text or true
  end
  vim.diagnostic.config { virtual_text = new_virtual_text }
  vim.notify(("Virtual text %s"):format(new_virtual_text and "on" or "off"))
end, { desc = "Toggle virtual text" })
local previous_virtual_lines
map("n", "<Leader>uV", function()
  local virtual_lines = vim.diagnostic.config().virtual_lines
  local new_virtual_lines = false
  if virtual_lines then
    previous_virtual_lines = virtual_lines
  else
    new_virtual_lines = previous_virtual_lines or true
  end
  vim.diagnostic.config { virtual_lines = new_virtual_lines }
  vim.notify(("Virtual lines %s"):format(new_virtual_lines and "on" or "off"))
end, { desc = "Toggle virtual lines" })
map("n", "<Leader>uy", function()
  local bufnr = vim.api.nvim_win_get_buf(0)
  if vim.bo[bufnr].syntax == "off" then
    pcall(vim.treesitter.start, bufnr)
    vim.bo[bufnr].syntax = "on"
  else
    pcall(vim.treesitter.stop, bufnr)
    vim.bo[bufnr].syntax = "off"
  end
  vim.notify(("syntax %s"):format(vim.bo[bufnr].syntax))
end, { desc = "Toggle syntax highlight (buffer)" })
