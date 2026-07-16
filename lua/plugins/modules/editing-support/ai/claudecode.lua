-- Claude Code 공식 Neovim IDE 확장
-- MCP 프로토콜을 통해 에디터↔Claude Code CLI 간 양방향 통신
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "VeryLazy",
  keys = {
    { "<Leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "x", desc = "Send to Claude Code" },
    { "<Leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to Claude" },
    { "<Leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<Leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    { "<Leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<Leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
  },
  opts = {
    terminal = {
      provider = "external",
      provider_opts = {
        external_terminal_cmd = function(cmd_string, env_table)
          return require("plugins.modules.editing-support.ai.claude-pane").external_cmd(cmd_string, env_table)
        end,
      },
    },
    models = {
      { name = "Claude Opus 4.6 (Latest)", value = "opus" },
      { name = "Claude Sonnet 4.6 (Latest)", value = "sonnet" },
      { name = "Opusplan: Opus 4.6 + Sonnet 4.6", value = "opusplan" },
      { name = "Claude Haiku 4.5", value = "haiku" },
    },
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
      open_in_current_tab = false,
    },
  },
}
