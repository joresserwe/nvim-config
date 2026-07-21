-- Pure Lua script that runs last, after all lazy.nvim plugin loading finishes.
-- Platform/terminal integrations hard to express as plugin specs are split out under lua/integrations/.

require "core.autocmds"
require "core.mappings"
require "lsp.setup"
require("highlights").setup()
require "integrations.term"
require "integrations.clipboard"
require "integrations.memo"
require("plugins.modules.editing-support.ai.claude-pane").setup()
