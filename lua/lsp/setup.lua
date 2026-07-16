-- Native LSP bootstrap. Loaded from polish.lua — server config merging is handled by the rtp lsp/ directory.
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
