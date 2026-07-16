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
