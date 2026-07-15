-- sindrets/diffview.nvim의 유지보수 포크 (drop-in 호환)
return {
  "dlyongemallo/diffview-plus.nvim",
  event = "User AstroGitFile",
  cmd = { "DiffviewOpen" },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { winbar_info = true },
      file_history = { winbar_info = true },
    },
    hooks = { diff_buf_read = function(bufnr) vim.b[bufnr].view_activated = false end },
  },
}
