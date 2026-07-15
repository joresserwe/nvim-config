---@param opts AstroCoreOpts
return function(opts)
  local is_available = function(plugin)
    return require("lazy.core.config").spec.plugins[plugin] ~= nil
  end
  local buffer = require "astrocore.buffer"
  local winbufs = require "core.winbufs"
  local get_icon = function(name, padding, no_fallback)
    local icons = {
      Window = "󰖮",
      Paste = "󰅌",
      Session = "",
      ActiveLSP = "",
    }
    local icon = icons[name] or (no_fallback and "" or "?")
    if padding and padding > 0 then icon = icon .. string.rep(" ", padding) end
    return icon
  end

  --- AstroNvim 기본 매핑을 새 prefix로 일괄 재할당
  ---@param tbl table mappings table
  ---@param mode string "n" | "v" | "x" ...
  ---@param old_prefix string 기존 prefix (e.g. "<Leader>d")
  ---@param new_prefix string 새 prefix (e.g. "<Leader>,")
  ---@param suffixes string[] 접미사 목록 (e.g. {"b", "B", "c"})
  ---@param section_key? string _map_sections 키 (없으면 old_prefix 마지막 글자)
  local function remap_prefix(tbl, mode, old_prefix, new_prefix, suffixes, section_key)
    section_key = section_key or old_prefix:sub(-1)
    tbl[mode][new_prefix] = vim.tbl_get(opts, "_map_sections", section_key)
    for _, s in ipairs(suffixes) do
      tbl[mode][new_prefix .. s] = vim.tbl_get(opts, "mappings", mode, old_prefix .. s)
    end
  end

  --- 키 목록 일괄 비활성화
  local function disable_keys(tbl, mode, keys)
    for _, key in ipairs(keys) do
      tbl[mode][key] = false
    end
  end

  opts._map_sections = vim.tbl_deep_extend("force", opts._map_sections or {}, {
    s = { desc = get_icon("Window", 1, true) .. "Show" },
    p = { desc = get_icon("Paste", 1, true) .. "Paste" },
  })

  ---------------------------------------------------------------------------
  -- 기본 매핑
  ---------------------------------------------------------------------------
  local mappings = vim.tbl_deep_extend("force", { [""] = {}, n = {}, v = {}, x = {}, i = {}, t = {}, o = {}, s = {} }, {
    [""] = {
      ["("] = { "7k", desc = "7줄 위로" },
      [")"] = { "7j", desc = "7줄 아래로" },
      ["x"] = { '"_x' },
      ["c"] = { '"_c' },
      ["y"] = { '"iy', desc = "yank (inner reg)" },
      ["Y"] = { '"+y', desc = "yank (system clipboard)" },
      ["d"] = { '"dd', desc = "delete (del reg)" },
      ["ps"] = { '"+p', desc = "paste from system clipboard" },
      ["pi"] = { '"ip', desc = "paste from inner clipboard ('k')" },
      ["pd"] = { '"dp', desc = "paste from deleted" },
      ["Ps"] = { '"+P', desc = "paste from system clipboard" },
      ["Pi"] = { '"iP', desc = "paste from inner clipboard ('k')" },
      ["Pd"] = { '"dP', desc = "paste from deleted" },
    },
    n = {
      -- copy & paste
      ["<Leader>c"] = { '"_ciw', desc = "단어 편집" },
      ["<Leader>x"] = { "viwx", remap = true, desc = "단어 제거 (inner reg)" },
      ["<Leader>d"] = { "viwd", remap = true, desc = "단어 제거 (del reg)" },
      ["<Leader>p"] = vim.tbl_get(opts, "_map_sections", "p"),
      ["<Leader>pi"] = { 'viw"_x"iP', desc = "paste from inner clipboard('i')" },
      ["<Leader>pd"] = { 'viw"_x"dP', desc = "paste from deleted" },
      ["<Leader>ps"] = { 'viw"_xP', desc = "paste from system clipboard" },
      ["yy"] = { '"iyy' },
      ["Yy"] = { '"+yy' },
      ["YY"] = { '"+yy' },
      ["dd"] = { '"ddd' },

      ["<C-a>"] = { "gg<S-v>G", desc = "전체 선택" },

      ["<S-h>"] = { "h", desc = "오타 방지" },
      ["<S-l>"] = { "l", desc = "오타 방지" },

      ["<Leader>o"] = { "o<ESC>", desc = "아래로 한줄 띄기" },
      ["<Leader>O"] = { "O<ESC>", desc = "위로 한줄 띄기" },
      ["<Leader><CR>"] = { "i<CR><ESC>k", desc = "현재 커서 위치에서 줄바꿈" },

      ["s"] = vim.tbl_get(opts, "_map_sections", "s"),
      ["sq"] = { "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },

      -- Prevent conflict <C-i> and <Tab>
      ["<C-p>"] = { "<C-o>", desc = "Jumplist back" },
      ["<C-n>"] = { "<C-i>", desc = "Jumplist forward" },
      ["<C-o>"] = { "<Nop>", desc = "Disabled (use <C-p>)" },

      -- Split
      ["<Leader>\\"] = { "<C-w>v", desc = "세로 분할" },
      ["<Leader>-"] = { "<C-w>s", desc = "가로 분할" },
      ["<Leader>="] = { "<C-w>x", desc = "분할창 순서 변경" },

      ["<Leader>w"] = { winbufs.close, desc = "현재 창의 버퍼 닫기 (pane 단위)" },

      -- surround
      ["<Leader>y"] = { "ysiw", remap = true, desc = "Surround word" },
    },
    x = {
      ["J"] = { ":move '>+1<CR>gv-gv", desc = "한줄 아래로 내림" },
      ["K"] = { ":move '<-2<CR>gv-gv", desc = "한줄 위로 올림" },
      ["<"] = { "<gv" },
      [">"] = { ">gv" },
      ["mf"] = { "<C-v>^<S-i>", desc = "Block insert (앞)" },
      ["mb"] = { "<C-v>$<S-a>", desc = "Block append (뒤)" },
    },
    t = {
      ["<C-w>"] = { [[<C-\><C-n><C-w>]], remap = true, desc = "창 명령" },
    },
  })

  ---------------------------------------------------------------------------
  -- Yanky
  ---------------------------------------------------------------------------
  if is_available "yanky.nvim" and is_available "snacks.nvim" then
    local yanky = function() require("snacks").picker.yanky() end
    mappings.n["<Leader>fy"] = { yanky, desc = "Find yanks" }
    mappings.x["<Leader>fy"] = { yanky, desc = "Find yanks" }
    mappings.n["sy"] = { yanky, desc = "Find yanks" }
    mappings.x["sy"] = { yanky, desc = "Find yanks" }
  end

  ---------------------------------------------------------------------------
  -- Todo Comments
  ---------------------------------------------------------------------------
  if is_available "todo-comments.nvim" and is_available "snacks.nvim" then
    local todo = function() require("snacks").picker.todo_comments() end
    mappings.n["<Leader>ft"] = { todo, desc = "Find todos" }
  end

  ---------------------------------------------------------------------------
  -- NeoTree
  ---------------------------------------------------------------------------
  if is_available "neo-tree.nvim" then
    mappings.n["<Leader>e"] = {
      function()
        if vim.bo.filetype == "neo-tree" then
          vim.cmd.Neotree "toggle"
        else
          vim.cmd.Neotree "focus"
        end
      end,
      desc = "Toggle Explorer",
    }
  end

  ---------------------------------------------------------------------------
  -- BufferLine
  ---------------------------------------------------------------------------
  if is_available "bufferline.nvim" then
    mappings.n["<tab>"] = { function() require("bufferline").cycle(1) end, desc = "Next buffer" }
    mappings.n["<S-tab>"] = { function() require("bufferline").cycle(-1) end, desc = "Previous buffer" }
  else
    mappings.n["<tab>"] = {
      function() buffer.nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    }
    mappings.n["<S-tab>"] = {
      function() buffer.nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    }
  end

  ---------------------------------------------------------------------------
  -- Snacks Picker
  ---------------------------------------------------------------------------
  if is_available "snacks.nvim" then
    local pick = function(name, picker_opts)
      return function() require("snacks").picker[name](picker_opts or {}) end
    end

    mappings.n["fd"] = { pick "diagnostics", desc = "Search diagnostics" }
    mappings.n["<Leader>f`"] = { pick "marks", desc = "Find marks" }
    mappings.n["<Leader>f'"] = { pick "registers", desc = "Find registers" }
    mappings.n["<Leader>f/"] = { pick "grep", desc = "Find words" }
    mappings.n["<Leader>f?"] = {
      pick("grep", { hidden = true, ignored = false }),
      desc = "Find words(숨김파일포함)",
    }
    mappings.n["<Leader>fe"] = {
      pick("recent", { filter = { cwd = true } }),
      desc = "Find history in CWD",
    }
    mappings.n["<Leader>fE"] = { pick "recent", desc = "Find history All Path" }
    mappings.n["<Leader>fs"] = { "<cmd>Namu symbols<cr>", desc = "Search symbols (Namu)" }
    mappings.n["<Leader>fS"] = { pick "lsp_symbols", desc = "Search symbols (Snacks)" }
    mappings.n["<Leader>fz"] = { pick "zoxide", desc = "Find directories" }
    mappings.n["<Leader>fu"] = { pick "undo", desc = "Find Undo" }
    mappings.n["<Leader>fl"] = { pick "lines", desc = "Find Lines" }

    mappings.n["su"] = { pick "undo", desc = "Find Undo" }
  end

  ---------------------------------------------------------------------------
  -- Trouble
  ---------------------------------------------------------------------------
  if is_available "trouble.nvim" then
    mappings.n["sd"] = { "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" }
    mappings.n["sD"] = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" }
  end

  ---------------------------------------------------------------------------
  -- Session (persistence.nvim)
  ---------------------------------------------------------------------------
  if is_available "persistence.nvim" then
    local persistence = function(method) return function() require("persistence")[method]() end end
    mappings.n["<Leader>s"] = { desc = get_icon("Session", 1, true) .. "Session" }
    mappings.n["<Leader>ss"] = { persistence "load", desc = "Load current dir session" }
    mappings.n["<Leader>sl"] = { persistence "select", desc = "Select session" }
    mappings.n["<Leader>sd"] = { persistence "stop", desc = "Stop session tracking" }
  end

  ---------------------------------------------------------------------------
  -- Multicursor
  ---------------------------------------------------------------------------
  if is_available "multicursors.nvim" then
    mappings.n["mm"] = { function() require("multicursors").start() end, desc = "multicursor start" }
    mappings.n["m/"] = { function() require("multicursors").new_pattern() end, desc = "multicursor search" }
    mappings.x["mm"] = { function() require("multicursors").search_visual() end, desc = "multicursor search" }
  end

  ---------------------------------------------------------------------------
  -- Plugin Manager (<Leader>p => <Leader>')
  ---------------------------------------------------------------------------
  remap_prefix(mappings, "n", "<Leader>p", "<Leader>'", { "i", "s", "S", "u", "U", "a", "m", "M" }, "p")

  ---------------------------------------------------------------------------
  -- Debugger (<Leader>d => <Leader>,)
  ---------------------------------------------------------------------------
  if is_available "nvim-dap" then
    remap_prefix(
      mappings,
      "n",
      "<Leader>d",
      "<Leader>,",
      { "b", "B", "c", "C", "i", "o", "O", "q", "Q", "p", "r", "R", "s" },
      "d"
    )

    if is_available "nvim-dap-view" then
      mappings.n["<Leader>,u"] = { "<cmd>DapViewToggle<cr>", desc = "Toggle Debugger UI" }
    end
  end

  ---------------------------------------------------------------------------
  -- Outline
  ---------------------------------------------------------------------------
  if is_available "outline.nvim" then
    mappings.n["sh"] = { "<cmd>Outline<CR>", desc = "Symbols outline(Hierarchy)" }
  end

  ---------------------------------------------------------------------------
  -- Terminal
  ---------------------------------------------------------------------------
  mappings.n["<Leader>t-"] = {
    function() Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 10 } }) end,
    desc = "Terminal horizontal split",
  }
  mappings.n["<Leader>t\\"] = {
    function() Snacks.terminal.toggle(nil, { win = { position = "right", width = 80 } }) end,
    desc = "Terminal vertical split",
  }

  ---------------------------------------------------------------------------
  -- AI 통합 (<Leader>a)
  ---------------------------------------------------------------------------
  mappings.n["<Leader>a"] = { desc = get_icon("ActiveLSP", 1, true) .. "AI" }

  -- Claude Code (외부 pane + IDE 통합)
  local claude_pane = require("plugins.modules.editing-support.ai.claude-pane")
  if claude_pane.is_available() then
    mappings.n["<Leader>ac"] = { claude_pane.open, desc = "Open Claude Code pane" }
  end
  if is_available "claudecode.nvim" then
    mappings.x["<Leader>as"] = { "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude Code" }
    mappings.n["<Leader>ab"] = { "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to Claude" }
    mappings.n["<Leader>aa"] = { "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" }
    mappings.n["<Leader>ad"] = { "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" }
    mappings.n["<Leader>ar"] = { "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" }
    mappings.n["<Leader>am"] = { "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" }
  end


  ---------------------------------------------------------------------------
  -- AutoSave
  ---------------------------------------------------------------------------
  if is_available "auto-save.nvim" then
    mappings.n["<Leader>uA"] = { "<cmd>ASToggle<cr>", desc = "Toggle Autosave" }
  end

  ---------------------------------------------------------------------------
  -- Focus
  ---------------------------------------------------------------------------
  mappings.n["<Leader>m"] = {
    function()
      local cur = vim.api.nvim_get_current_win()
      if vim.g.maximised_win == cur then
        vim.cmd "wincmd ="
        vim.g.maximised_win = nil
      else
        vim.cmd "wincmd _ | wincmd |"
        vim.g.maximised_win = cur
      end
    end,
    desc = "Maximize/equalize window",
  }

  ---------------------------------------------------------------------------
  -- Windows
  ---------------------------------------------------------------------------


  ---------------------------------------------------------------------------
  -- Conform (Formatting)
  ---------------------------------------------------------------------------
  if is_available "conform.nvim" then
    local format = function() require("conform").format { async = false } end
    mappings.n[";f"] = { format, desc = "Format buffer" }
    mappings.v[";f"] = { format, desc = "Format buffer(Visual)" }
    mappings.n["<Leader>lc"] = { "<cmd>ConformInfo<cr>", desc = "Conform Information" }
  end


  ---------------------------------------------------------------------------
  -- 비활성화 (AstroNvim 기본 매핑 제거)
  ---------------------------------------------------------------------------
  mappings.n["|"] = false
  mappings.n["\\"] = false
  mappings[""]["s"] = "<Nop>"
  mappings.n["p"] = "<Nop>"
  mappings.n["P"] = "<Nop>"

  disable_keys(mappings, "n", {
    "<Leader>C",
    -- Sessions (=> <Leader>s 로 이동)
    "<Leader>S", "<Leader>S.", "<Leader>Sd", "<Leader>SD",
    "<Leader>Sf", "<Leader>SF", "<Leader>Sl", "<Leader>Ss", "<Leader>SS", "<Leader>St",
    -- Debugger (=> <Leader>, 로 이동)
    "<Leader>db", "<Leader>dB", "<Leader>dc", "<Leader>dC", "<Leader>dE",
    "<Leader>dh", "<Leader>di", "<Leader>do", "<Leader>dO", "<Leader>dp",
    "<Leader>dq", "<Leader>dQ", "<Leader>dr", "<Leader>dR", "<Leader>ds", "<Leader>du",
    -- Finder (재할당 또는 미사용)
    "<Leader>fb", "<Leader>fo", "<Leader>fO", "<Leader>fr", "<Leader>fw", "<Leader>fW",
    -- LSP
    "<Leader>lD", "<Leader>lS", "<Leader>ls",
    -- Plugins (=> <Leader>' 로 이동)
    "<Leader>pa", "<Leader>pm", "<Leader>pM", "<Leader>pS", "<Leader>pu", "<Leader>pU",
    -- Terminal
    "<Leader>th", "<Leader>tl", "<Leader>tv",
    -- 기타
    "<Leader>h", "<Leader>lf", "<Leader>Mp", "<Leader>Ms", "<Leader>Mt",
    "<Leader>xl", "<Leader>xq",
  })

  return mappings
end
