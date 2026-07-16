local filtered_messages = {
  "vim.tbl_islist is deprecated",
  -- Add messages to ignore here.
}

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    notifier = {
      filter = function(notif)
        if notif.msg then
          for _, pattern in ipairs(filtered_messages) do
            if notif.msg:match(pattern) then return false end
          end
        end
        return true
      end,
    },
  },
}
