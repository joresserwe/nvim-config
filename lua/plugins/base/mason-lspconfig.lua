local function is_available(plugin) return require("lazy.core.config").spec.plugins[plugin] ~= nil end

return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
  event = "User AstroFile",
  cmd = { "LspInstall", "LspUninstall" },
  opts_extend = { "ensure_installed" },
  opts = { ensure_installed = {} },
  config = function(_, opts)
    if is_available "mason-tool-installer.nvim" then opts.ensure_installed = nil end
    require("mason-lspconfig").setup(opts)
  end,
}
