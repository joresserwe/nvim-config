---@type LazySpec
return {
  -- Manual resize: <C-w>r enters resize mode, hjkl to adjust.
  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    dependencies = { "pogyomo/submode.nvim" },
    config = function()
      require("smart-splits").setup {
        -- wezterm.lua's is_vim() + ActivatePaneDirection already handle nvim↔pane switching,
        -- so disable mux integration (avoids the sync wezterm.exe cli call latency on WSL).
        multiplexer_integration = false,
      }

      local submode = require "submode"
      vim.keymap.set("n", "<C-w><C-r>", "<C-w>r", { remap = true, desc = "Resize mode" })

      submode.create("WinResize", {
        mode = "n",
        enter = "<C-w>r",
        desc = "Resize mode",
        leave = { "<Esc>", "q", "<C-c>" },
        hook = {
          on_enter = function() vim.notify "Resize mode: h/j/k/l to resize, <Esc> to exit" end,
          on_leave = function() vim.notify "" end,
        },
        default = function(register)
          register("h", require("smart-splits").resize_left, { desc = "Resize left" })
          register("j", require("smart-splits").resize_down, { desc = "Resize down" })
          register("k", require("smart-splits").resize_up, { desc = "Resize up" })
          register("l", require("smart-splits").resize_right, { desc = "Resize right" })
        end,
      })
    end,
  },
}
