-- WezTerm backend: IS_NVIM user_var broadcast.
-- Emit OSC 1337 sequences so wezterm.lua's is_vim() works via an O(1)
-- pane:get_user_vars() lookup instead of a proc-tree walk (get_foreground_process_name).

-- Broadcast the user_vars below over OSC 1337 so wezterm's Ctrl+hjkl callback can pick
-- SendKey / ActivatePaneDirection directly, without a sync `wezterm cli` call.
--   IS_NVIM           : nvim is running in this pane
--   NVIM_AT_{LEFT,...} : the current nvim window is at that directional edge
local function set_var(key, val)
  io.stdout:write("\027]1337;SetUserVar=" .. key .. "=" .. vim.base64.encode(val) .. "\007")
  io.stdout:flush()
end

local edge_dirs = { LEFT = "h", RIGHT = "l", UP = "k", DOWN = "j" }
local function update_edges()
  local cur = vim.fn.winnr()
  for name, key in pairs(edge_dirs) do
    set_var("NVIM_AT_" .. name, vim.fn.winnr(key) == cur and "1" or "")
  end
end
local function setup_all()
  set_var("IS_NVIM", "1")
  update_edges()
end

vim.api.nvim_create_autocmd({ "UIEnter", "VimEnter", "VimResume", "FocusGained" }, {
  callback = function() vim.schedule(setup_all) end,
  desc = "wezterm: set IS_NVIM + edge flags",
})
vim.api.nvim_create_autocmd({ "WinEnter", "WinResized", "VimResized", "WinNew", "WinClosed" }, {
  callback = function() vim.schedule(update_edges) end,
  desc = "wezterm: refresh edge flags",
})
vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
  callback = function()
    set_var("IS_NVIM", "")
    for name in pairs(edge_dirs) do
      set_var("NVIM_AT_" .. name, "")
    end
  end,
  desc = "wezterm: clear IS_NVIM + edge flags",
})
