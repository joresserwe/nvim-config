-- 네이티브 LSP 부트스트랩. polish.lua에서 로드 — 서버 설정 병합은 rtp lsp/ 디렉토리가 담당한다.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then capabilities = blink.get_lsp_capabilities(capabilities) end
vim.lsp.config("*", { capabilities = capabilities })

vim.lsp.enable {
  "bashls",
  "cssls",
  "emmet_ls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "stylua",
  "tailwindcss",
  "vtsls",
}

vim.lsp.inlay_hint.enable(true)

require "lsp.attach"
