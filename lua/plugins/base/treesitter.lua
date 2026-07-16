-- nvim-treesitter(main) 네이티브 설정기
local M = {}

local installed = {}
local installed_checked = false
local available
local queries = {}
local captures = {}
local state = {}
local indentexprs = {}

local config = {}

M.textobject_modes = {
  select = { "x", "o" },
  swap = { "n" },
  move = { "n", "x", "o" },
}

function M.installed(update)
  if update then
    local ok, ts = pcall(require, "nvim-treesitter")
    if ok then
      installed, queries = {}, {}
      for _, lang in ipairs(ts.get_installed "parsers") do
        installed[lang] = true
      end
      installed_checked = true
    end
  end
  return installed
end

function M.available()
  if available == nil then
    available = {}
    local ok, ts = pcall(require, "nvim-treesitter")
    if ok then
      for _, parser in ipairs(ts.get_available()) do
        available[parser] = true
      end
    end
  end
  return available
end

function M.install(languages, cb)
  local ok, ts = pcall(require, "nvim-treesitter")
  if not ok then return end
  if vim.fn.executable "tree-sitter" == 0 then
    vim.notify_once("treesitter: tree-sitter CLI 없음 — :MasonToolsInstall 후 재시작하면 파서가 설치됩니다", vim.log.levels.WARN)
    return
  end
  if not languages then
    local lang = vim.treesitter.language.get_lang(vim.bo[vim.api.nvim_get_current_buf()].filetype)
    languages = M.available()[lang] and { lang } or {}
  elseif languages == "all" then
    languages = ts.get_available()
  end
  languages = vim.tbl_filter(function(lang) return not M.has_parser(lang) end, languages)
  if next(languages) then
    ts.install(languages, { summary = true }):await(function()
      M.installed(true)
      if cb then cb() end
    end)
  end
end

function M.has_capture(lang, query, capture)
  local key = lang .. ":" .. query
  if captures[key] == nil then
    captures[key] = {}
    local found_captures = (vim.treesitter.query.get(lang, query) or {}).captures
    for _, found_capture in ipairs(found_captures or {}) do
      captures[key][found_capture] = true
    end
  end
  return captures[key][capture] == true
end

function M.has_query(lang, query)
  local key = lang .. ":" .. query
  if queries[key] == nil then queries[key] = vim.treesitter.query.get(lang, query) ~= nil end
  return queries[key]
end

function M.has_parser(filetype, query)
  if not filetype then filetype = vim.api.nvim_get_current_buf() end
  if type(filetype) == "number" then filetype = vim.bo[filetype].filetype end
  local lang = vim.treesitter.language.get_lang(filetype)
  if not lang or not M.installed()[lang] then return false end
  if query and not M.has_query(lang, query) then return false end
  return true
end

function M.enable(bufnr)
  if not bufnr then bufnr = vim.api.nvim_get_current_buf() end
  if not vim.api.nvim_buf_is_valid(bufnr) then return end
  local ft = vim.bo[bufnr].filetype
  local lang = vim.treesitter.language.get_lang(ft)
  if not M.has_parser(ft) or not lang then return end
  state[bufnr] = true

  local function feature_enabled(feat, query)
    local enable = config[feat]
    if type(enable) == "table" then
      enable = vim.tbl_contains(enable, lang)
    elseif type(enable) == "function" then
      enable = enable(lang, bufnr)
    end
    return enable and M.has_parser(ft, query)
  end

  if feature_enabled("highlight", "highlights") then pcall(vim.treesitter.start, bufnr) end

  if feature_enabled("indent", "indents") then
    indentexprs[bufnr] = vim.bo[bufnr].indentexpr
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end

  if M.has_parser(ft, "folds") then vim.wo.foldmethod = vim.wo.foldmethod end

  if config.textobjects and pcall(require, "nvim-treesitter-textobjects") then
    for type, methods in pairs(config.textobjects) do
      local mode = M.textobject_modes[type]
      for method, keys in pairs(methods) do
        for key, opts in pairs(keys) do
          local group = opts.group or "textobjects"
          if M.has_capture(lang, group, string.sub(opts.query, 2)) then
            vim.keymap.set(
              mode,
              key,
              function() require("nvim-treesitter-textobjects." .. type)[method](opts.query, group) end,
              { buffer = bufnr, desc = opts.desc, silent = true }
            )
          end
        end
      end
    end
  end
end

function M.disable(bufnr)
  if not bufnr then bufnr = vim.api.nvim_get_current_buf() end
  state[bufnr] = false
  pcall(vim.treesitter.stop, bufnr)
  if indentexprs[bufnr] then vim.bo[bufnr].indentexpr = indentexprs[bufnr] end
  vim.schedule(function() vim.cmd "normal! zx" end)
end

local function setup()
  local user = require("lsp.installer").treesitter
  local base = { "bash", "c", "lua", "markdown", "markdown_inline", "python", "query", "regex", "vim", "vimdoc" }
  local ensure = {}
  local seen = {}
  for _, list in ipairs { base, user.ensure_installed } do
    for _, lang in ipairs(list) do
      if not seen[lang] then
        seen[lang] = true
        ensure[#ensure + 1] = lang
      end
    end
  end

  config = {
    enabled = function(_, bufnr) return not vim.b[bufnr].large_buf end,
    highlight = user.highlight,
    indent = user.indent,
    auto_install = user.auto_install,
    ensure_installed = ensure,
    textobjects = {
      select = {
        select_textobject = {
          ["ak"] = { query = "@block.outer", desc = "around block" },
          ["ik"] = { query = "@block.inner", desc = "inside block" },
          ["ac"] = { query = "@class.outer", desc = "around class" },
          ["ic"] = { query = "@class.inner", desc = "inside class" },
          ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
          ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
          ["af"] = { query = "@function.outer", desc = "around function" },
          ["if"] = { query = "@function.inner", desc = "inside function" },
          ["ao"] = { query = "@loop.outer", desc = "around loop" },
          ["io"] = { query = "@loop.inner", desc = "inside loop" },
          ["aa"] = { query = "@parameter.outer", desc = "around argument" },
          ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
        },
      },
      move = {
        goto_next_start = {
          ["]k"] = { query = "@block.outer", desc = "Next block start" },
          ["]f"] = { query = "@function.outer", desc = "Next function start" },
          ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
        },
        goto_next_end = {
          ["]K"] = { query = "@block.outer", desc = "Next block end" },
          ["]F"] = { query = "@function.outer", desc = "Next function end" },
          ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
        },
        goto_previous_start = {
          ["[k"] = { query = "@block.outer", desc = "Previous block start" },
          ["[f"] = { query = "@function.outer", desc = "Previous function start" },
          ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
        },
        goto_previous_end = {
          ["[K"] = { query = "@block.outer", desc = "Previous block end" },
          ["[F"] = { query = "@function.outer", desc = "Previous function end" },
          ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
        },
      },
      swap = {
        swap_next = {
          [">K"] = { query = "@block.outer", desc = "Swap next block" },
          [">F"] = { query = "@function.outer", desc = "Swap next function" },
          [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
        },
        swap_previous = {
          ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
          ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
          ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
        },
      },
    },
  }

  M.installed(true)
  M.install(config.ensure_installed)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("base_treesitter", { clear = true }),
    desc = "Automatically detect available treesitter parsers and enable necessary features",
    callback = function(args)
      if state[args.buf] == false then return end
      local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
      if not lang then return end
      local _enabled = config.enabled
      if type(_enabled) == "function" then _enabled = _enabled(lang, args.buf) end
      if _enabled then
        if not installed_checked then M.installed(true) end
        if not M.has_parser(args.match) then
          if config.auto_install then M.install(nil, function() M.enable(args.buf) end) end
        else
          M.enable(args.buf)
        end
      else
        M.disable(args.buf)
      end
    end,
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = "VeryLazy",
    lazy = vim.fn.argc(-1) == 0,
    cmd = { "TSInstall", "TSInstallFromGrammar", "TSUninstall", "TSUpdate", "TSLog" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = true,
    opts = {
      select = { lookahead = true },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = "User AstroFile",
    opts = {},
  },
}
