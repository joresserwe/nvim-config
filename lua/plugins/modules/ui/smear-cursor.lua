-- Smear (trail) animation on cursor movement.
return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  cond = false,
  opts = {
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    scroll_buffer_space = true,
    hide_target_hack = true,
  },
}
