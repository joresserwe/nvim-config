return {
  "mason-org/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
  build = ":MasonUpdate",
  opts_extend = { "registries" },
  opts = function(_, opts)
    if not opts.registries then opts.registries = {} end
    table.insert(opts.registries, "github:mason-org/mason-registry")
    if not opts.ui then opts.ui = {} end
    opts.ui.icons = {
      package_installed = "\u{2713}",
      package_uninstalled = "\u{2717}",
      package_pending = "\u{27f3}",
    }
  end,
}
