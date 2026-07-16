-- lazy.nvim 플러그인 로딩이 모두 끝난 뒤 마지막에 실행되는 순수 Lua 스크립트.
-- 플러그인 spec으로 표현하기 어려운 플랫폼/터미널 통합을 lua/integrations/ 아래에 분리.

require "core.mappings"
require "lsp.setup"
require "integrations.wezterm"
require "integrations.clipboard"
require("plugins.modules.editing-support.ai.claude-pane").setup()
