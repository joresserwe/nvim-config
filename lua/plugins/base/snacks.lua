local function is_valid(bufnr) return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted end
local function is_large(bufnr) return vim.b[bufnr].large_buf == true end

return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = function(_, opts)
    local icons = require "core.icons"

    opts.dashboard = {
      width = 50,
      preset = {
        keys = {
          { key = "f", action = "<Leader>ff", icon = icons.get "Search", desc = "Find File" },
          { key = "g", action = "<Leader>f/", icon = icons.get "WordFile", desc = "Grep" },
          { key = "r", action = "<Leader>fe", icon = icons.get "DefaultFile", desc = "Recent Files" },
          { key = "s", action = "<Leader>sl", icon = icons.get "Session", desc = "Last Session" },
          { key = "n", action = "<Leader>n", icon = icons.get "FileNew", desc = "New File" },
        },
      },
      sections = {
        function()
          local logo = {
            { [[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]], "#65bcff" },
            { [[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]], "#61a6f9" },
            { [[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]], "#6d8df5" },
            { [[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]], "#8a7ff0" },
            { [[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]], "#a878ec" },
            { [[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]], "#c974e6" },
          }
          for name, hl in pairs {
            SnacksDashboardIcon = { fg = "#65bcff" },
            SnacksDashboardDesc = { fg = "#9aa5ce" },
            SnacksDashboardKey = { fg = "#c974e6", bold = true },
            SnacksDashboardFooter = { fg = "#9aa5ce", italic = true },
            SnacksDashboardSpecial = { fg = "#8a7ff0" },
          } do
            vim.api.nvim_set_hl(0, name, hl)
          end
          local items = { { text = { { "" } }, padding = 1 } }
          for i, line in ipairs(logo) do
            vim.api.nvim_set_hl(0, "DashLogo" .. i, { fg = line[2], bold = true })
            items[#items + 1] = { text = { { line[1], hl = "DashLogo" .. i } } }
          end
          items[#items].padding = 3
          return items
        end,
        { section = "keys", gap = 1, padding = 3 },
        function()
          local stats = require("lazy.stats").stats()
          local ms = math.floor(stats.startuptime + 0.5)
          return {
            align = "center",
            text = {
              { "⚡ " .. ms .. "ms", hl = "special" },
              { "  ·  ", hl = "footer" },
              { stats.loaded .. "/" .. stats.count .. " plugins", hl = "footer" },
            },
          }
        end,
      },
    }

    opts.image = { doc = { enabled = false } }
    opts.input = {}

    opts.notifier = {}
    opts.notifier.icons = {
      debug = icons.get "Debugger",
      error = icons.get "DiagnosticError",
      info = icons.get "DiagnosticInfo",
      trace = icons.get "DiagnosticHint",
      warn = icons.get "DiagnosticWarn",
    }

    opts.picker = { ui_select = true }

    opts.indent = {
      indent = { char = "▏" },
      scope = { char = "▏" },
      filter = function(bufnr)
        return is_valid(bufnr)
          and not is_large(bufnr)
          and vim.g.snacks_indent ~= false
          and vim.b[bufnr].snacks_indent ~= false
      end,
      animate = { enabled = false },
    }

    opts.scope = {
      filter = function(bufnr)
        return is_valid(bufnr)
          and not is_large(bufnr)
          and vim.g.snacks_scope ~= false
          and vim.b[bufnr].snacks_scope ~= false
      end,
    }

    opts.words = {
      enabled = true,
      filter = function(bufnr)
        return is_valid(bufnr)
          and not is_large(bufnr)
          and vim.g.snacks_words ~= false
          and vim.b[bufnr].snacks_words ~= false
      end,
    }

    opts.zen = {
      toggles = { dim = false, diagnostics = false, inlay_hints = false },
      on_open = function(win)
        vim.b[win.buf].snacks_indent_old = vim.b[win.buf].snacks_indent
        vim.b[win.buf].snacks_indent = false
      end,
      on_close = function(win) vim.b[win.buf].snacks_indent = vim.b[win.buf].snacks_indent_old end,
      win = {
        width = function() return math.min(120, math.floor(vim.o.columns * 0.75)) end,
        height = 0.9,
        backdrop = {
          transparent = false,
          win = { wo = { winhighlight = "Normal:Normal" } },
        },
        wo = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
          foldcolumn = "0",
          winbar = "",
          list = false,
          showbreak = "NONE",
        },
      },
    }
  end,
  keys = function()
    local keys = {
      { "<Leader>u|", function() require("snacks").toggle.indent():toggle() end, desc = "Toggle indent guides" },
      { "<Leader>uD", function() require("snacks.notifier").hide() end, desc = "Dismiss notifications" },
      { "<Leader>uZ", function() require("snacks").toggle.zen():toggle() end, desc = "Toggle zen mode" },
      { "<Leader>ur", function() require("snacks").toggle.words():toggle() end, desc = "Toggle reference highlighting" },
      { "]r", function() require("snacks").words.jump(vim.v.count1) end, desc = "Next reference" },
      { "[r", function() require("snacks").words.jump(-vim.v.count1) end, desc = "Previous reference" },
      { "<Leader>f<CR>", function() require("snacks").picker.resume() end, desc = "Resume previous search" },
      {
        "<Leader>fa",
        function() require("snacks").picker.files { dirs = { vim.fn.stdpath "config" }, desc = "Config Files" } end,
        desc = "Find config files",
      },
      { "<Leader>fc", function() require("snacks").picker.grep_word() end, desc = "Find word under cursor" },
      { "<Leader>fC", function() require("snacks").picker.commands() end, desc = "Find commands" },
      {
        "<Leader>ff",
        function()
          require("snacks").picker.files {
            hidden = vim.tbl_get((vim.uv or vim.loop).fs_stat ".git" or {}, "type") == "directory",
          }
        end,
        desc = "Find files",
      },
      { "<Leader>fF", function() require("snacks").picker.files { hidden = true, ignored = true } end, desc = "Find all files" },
      { "<Leader>fg", function() require("snacks").picker.git_files() end, desc = "Find git files" },
      { "<Leader>fh", function() require("snacks").picker.help() end, desc = "Find help" },
      { "<Leader>fk", function() require("snacks").picker.keymaps() end, desc = "Find keymaps" },
      { "<Leader>fm", function() require("snacks").picker.man() end, desc = "Find man" },
      { "<Leader>fn", function() require("snacks").picker.notifications() end, desc = "Find notifications" },
      { "<Leader>fp", function() require("snacks").picker.projects() end, desc = "Find projects" },
      {
        "<Leader>ft",
        function()
          require("snacks").picker.colorschemes {
            transform = function(item) return not item.file:find(vim.env.VIMRUNTIME, 1, true) end,
          }
        end,
        desc = "Find themes",
      },
    }
    if vim.fn.executable "git" == 1 then
      vim.list_extend(keys, {
        { "<Leader>go", function() require("snacks").gitbrowse() end, mode = { "n", "x" }, desc = "Git browse (open)" },
        { "<Leader>gb", function() require("snacks").picker.git_branches() end, desc = "Git branches" },
        { "<Leader>gc", function() require("snacks").picker.git_log() end, desc = "Git commits (repository)" },
        {
          "<Leader>gC",
          function() require("snacks").picker.git_log { current_file = true, follow = true } end,
          desc = "Git commits (current file)",
        },
        { "<Leader>gt", function() require("snacks").picker.git_status() end, desc = "Git status" },
        { "<Leader>gT", function() require("snacks").picker.git_stash() end, desc = "Git stash" },
      })
    end
    return keys
  end,
}
