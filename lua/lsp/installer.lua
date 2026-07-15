local M = {}

-- use mason-tool-installer for automatically installing Mason packages
M.mason = function(_, opts)
  -- add more things to the ensure_installed table protecting against community packs modifying it
  opts.ensure_installed = opts.ensure_installed or {}
  vim.list_extend(opts.ensure_installed, {
    "eslint_d",
    "js-debug-adapter",
    "lua-language-server",
    "stylua",
    "vtsls",
    "tailwindcss-language-server",
    "html-lsp",
    "css-lsp",
    "emmet-ls",
    "prettierd",
    "stylelint",
    "bash-language-server",
    "shfmt",
    "shellcheck",
    "debugpy",
    "jdtls",
    "java-debug-adapter",
    "java-test",
    "tree-sitter-cli",
    "marksman",
    "mdformat",
    "json-lsp",
  })
end

-- Customize Treesitter
M.treesitter = {
  ensure_installed = {
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "jsdoc",
    "java",
    "bash",
    "markdown",
    "markdown_inline",
    "json",
    "json5",
    -- "lua",
    -- "luap",
    -- "yaml",
  },
  highlight = true,
  indent = true,
  auto_install = true,
}
return M
