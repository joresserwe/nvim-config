-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    local extend = function(a, b) return vim.tbl_deep_extend("force", a or {}, b or {}) end

    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    opts.diagnostics = extend(opts.diagnostics, require "core.diagnostics")

    -- Configure core features of AstroNvim
    opts.features = extend(opts.features, require("core.options").features)

    -- vim options can be configured here
    opts.options = extend(opts.options, require("core.options").options)

    -- filetype detection rules (see `:h vim.filetype.add`)
    opts.filetypes = extend(opts.filetypes, require("core.options").filetypes)

    -- Mappings can be configured through AstroCore as well.
    opts.mappings = extend(opts.mappings, require "core.astro-overrides"())

    -- User commands
    opts.commands = extend(opts.commands, require "core.commands")

    -- Treesitter configuration (highlight, indent, parsers)
    opts.treesitter = extend(opts.treesitter, require("lsp.installer").treesitter)
  end,
}
