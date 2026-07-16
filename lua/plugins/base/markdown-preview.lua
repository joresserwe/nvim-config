return {
  "iamcco/markdown-preview.nvim",
  build = "cd app && npm install",
  ft = { "markdown", "markdown.mdx" },
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  init = function()
    local plugin = require("lazy.core.config").spec.plugins["markdown-preview.nvim"]
    vim.g.mkdp_filetypes = require("lazy.core.plugin").values(plugin, "ft", true)
  end,
}
