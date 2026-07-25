-- Native LSP bootstrap. Loaded from polish.lua — server config merging is handled by the rtp lsp/ directory.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local blink_ok, blink = pcall(require, "blink.cmp")
if blink_ok then capabilities = blink.get_lsp_capabilities(capabilities) end
vim.lsp.config("*", { capabilities = capabilities })

-- Overrides upstream lspconfig's root list, which includes ".git" as a
-- tailwind-v4 fallback and so attaches the server to every git repo.
-- rtp lsp/ files can't override it: later rtp entries win the merge there.
vim.lsp.config("tailwindcss", {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, {
      "tailwind.config.js",
      "tailwind.config.cjs",
      "tailwind.config.mjs",
      "tailwind.config.ts",
      "postcss.config.js",
      "postcss.config.cjs",
      "postcss.config.mjs",
      "postcss.config.ts",
    })
    if root then return on_dir(root) end
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local pkg = vim.fs.find("package.json", { path = vim.fs.dirname(fname), upward = true })[1]
    if pkg then
      local ok, lines = pcall(vim.fn.readfile, pkg)
      if ok and table.concat(lines):find('"tailwindcss"', 1, true) then on_dir(vim.fs.dirname(pkg)) end
    end
  end,
})

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
