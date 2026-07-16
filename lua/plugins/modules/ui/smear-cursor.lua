-- Smear (trail) animation on cursor movement.
return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  cond = vim.g.neovide == nil, -- Neovide has its own cursor animation
  opts = {
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    scroll_buffer_space = true,
    hide_target_hack = true,
  },
}
