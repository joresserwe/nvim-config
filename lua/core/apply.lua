local icons = require "core.icons"

vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin:" .. vim.env.PATH

local merge = function(a, b) return vim.tbl_deep_extend("force", a or {}, b or {}) end

local base_opt = {
  backspace = vim.list_extend(vim.opt.backspace:get(), { "nostop" }),
  breakindent = true,
  clipboard = "unnamedplus",
  cmdheight = 0,
  completeopt = { "menu", "menuone", "noselect" },
  confirm = true,
  copyindent = true,
  cursorline = true,
  diffopt = vim.list_extend(vim.opt.diffopt:get(), { "algorithm:histogram", "linematch:60" }),
  expandtab = true,
  fillchars = {
    eob = " ",
    foldopen = icons.get "FoldOpened",
    foldclose = icons.get "FoldClosed",
    foldsep = icons.get "FoldSeparator",
    foldinner = vim.fn.has "nvim-0.12" == 1 and icons.get "FoldSeparator" or nil,
  },
  ignorecase = true,
  infercase = true,
  jumpoptions = {},
  laststatus = 3,
  linebreak = true,
  mouse = "a",
  number = true,
  preserveindent = true,
  pumheight = 10,
  relativenumber = true,
  shiftround = true,
  shiftwidth = 0,
  shortmess = vim.tbl_deep_extend("force", vim.opt.shortmess:get(), { s = true, I = true, c = true, C = true }),
  showmode = false,
  showtabline = 2,
  signcolumn = "yes",
  smartcase = true,
  splitbelow = true,
  splitright = true,
  tabclose = "uselast",
  tabstop = 2,
  termguicolors = true,
  timeoutlen = 500,
  title = true,
  undofile = true,
  updatetime = 300,
  virtualedit = "block",
  winborder = "rounded",
  wrap = false,
  writebackup = false,
}

local user = require "core.options"
local opt = merge(base_opt, (user.options or {}).opt)

opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldmethod = "expr"
opt.foldtext = ""
opt.foldcolumn = "0"
opt.foldenable = true

-- Defer clipboard setup (avoids the provider-discovery cost at startup).
local lazy_clipboard = opt.clipboard
opt.clipboard = nil
vim.schedule(function() vim.opt.clipboard = lazy_clipboard end)

for k, v in pairs(opt) do
  vim.opt[k] = v
end

local g = merge({ markdown_recommended_style = 0 }, (user.options or {}).g)
for k, v in pairs(g) do
  vim.g[k] = v
end

local base_diag = {
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.get "DiagnosticError",
      [vim.diagnostic.severity.HINT] = icons.get "DiagnosticHint",
      [vim.diagnostic.severity.WARN] = icons.get "DiagnosticWarn",
      [vim.diagnostic.severity.INFO] = icons.get "DiagnosticInfo",
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = { source = "if_many", header = "", prefix = "" },
  jump = {
    float = vim.fn.has "nvim-0.11" == 1 and true or nil,
    on_jump = function(_, bufnr) vim.diagnostic.open_float { bufnr = bufnr, scope = "cursor", focus = false } end,
  },
}
vim.diagnostic.config(merge(base_diag, require "core.diagnostics"))

-- user commands (core/commands.lua)
for name, spec in pairs(require "core.commands") do
  local fn = spec[1]
  vim.api.nvim_create_user_command(name, fn, {
    desc = spec.desc,
    bang = spec.bang,
    nargs = spec.nargs,
    complete = spec.complete,
  })
end

if not vim.t.bufs then vim.t.bufs = vim.api.nvim_list_bufs() end
