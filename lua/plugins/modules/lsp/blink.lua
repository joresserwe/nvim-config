local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

---@type function?
local icon_provider

local function get_kind_icon(CTX)
  if not icon_provider then
    local _, mini_icons = pcall(require, "mini.icons")
    if _G.MiniIcons then
      icon_provider = function(ctx)
        if ctx.item.source_name == "LSP" then
          local icon, hl = mini_icons.get("lsp", ctx.kind or "")
          if icon then
            ctx.kind_icon = icon
            ctx.kind_hl = hl
          end
        elseif ctx.item.source_name == "Path" then
          ctx.kind_icon, ctx.kind_hl = mini_icons.get(ctx.kind == "Folder" and "directory" or "file", ctx.label)
        end
      end
    end
    if not icon_provider then
      local lspkind_avail, lspkind = pcall(require, "lspkind")
      if lspkind_avail then
        icon_provider = function(ctx)
          if ctx.item.source_name == "LSP" then
            local icon = lspkind.symbolic(ctx.kind, { mode = "symbol" })
            if icon then ctx.kind_icon = icon end
          end
        end
      end
    end
    if not icon_provider then icon_provider = function() end end
  end
  icon_provider(CTX)
  return { text = CTX.kind_icon .. CTX.icon_gap, highlight = CTX.kind_hl }
end

return {
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "^1",
    dependencies = {
      { "moyiz/blink-emoji.nvim", lazy = true },
      "rafamadriz/friendly-snippets",
    },
    opts_extend = { "sources.default", "cmdline.sources", "term.sources" },
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "emoji" },
        providers = {
          emoji = { name = "emoji", module = "blink-emoji" },
        },
      },
      keymap = {
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-N>"] = { "select_next", "show" },
        ["<C-P>"] = { "select_prev", "show" },
        ["<C-J>"] = { "select_next", "fallback" },
        ["<C-K>"] = { "select_prev", "fallback" },
        ["<C-U>"] = { "scroll_documentation_up", "fallback" },
        ["<C-D>"] = { "scroll_documentation_down", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = {
          function()
            local ok, suggestion = pcall(require, "copilot.suggestion")
            if ok and suggestion.is_visible() then
              suggestion.accept()
              return true
            end
          end,
          "select_next",
          "snippet_forward",
          function(cmp)
            if has_words_before() or vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          "select_prev",
          "snippet_backward",
          function(cmp)
            if vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
          end,
          "fallback",
        },
      },
      completion = {
        ghost_text = { enabled = true },
        list = { selection = { preselect = false, auto_insert = true } },
        menu = {
          auto_show = function(ctx) return ctx.mode ~= "cmdline" end,
          border = "rounded",
          scrollbar = false,
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          draw = {
            treesitter = { "lsp" },
            components = {
              kind_icon = {
                text = function(ctx) return get_kind_icon(ctx).text end,
                highlight = function(ctx) return get_kind_icon(ctx).highlight end,
              },
            },
          },
        },
        accept = {
          auto_brackets = { enabled = true },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          window = {
            border = "rounded",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
          },
        },
      },
      signature = {
        window = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
      },
      -- Uses vim.snippet's built-in engine (friendly-snippets auto-loaded).
    },
    specs = {
      {
        "folke/lazydev.nvim",
        optional = true,
        specs = {
          {
            "saghen/blink.cmp",
            opts = function(_, opts)
              if pcall(require, "lazydev.integrations.blink") then
                return vim.tbl_deep_extend("force", opts, {
                  sources = {
                    default = { "lazydev" },
                    providers = {
                      lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
                    },
                  },
                })
              end
            end,
          },
        },
      },
      {
        "catppuccin",
        optional = true,
        ---@type CatppuccinOptions
        opts = { integrations = { blink_cmp = true } },
      },
    },
  },
}
