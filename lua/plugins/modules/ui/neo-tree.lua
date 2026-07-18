local function toggle_explorer()
  if vim.bo.filetype == "neo-tree" then
    vim.cmd.Neotree "toggle"
  else
    vim.cmd.Neotree "focus"
  end
end

local keys = {
  { "<Leader>e", toggle_explorer, desc = "Toggle Explorer" },
}
if require("core.platform").is_wsl then
  table.insert(keys, { "<M-1>", toggle_explorer, desc = "Toggle Explorer" })
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = keys,
  opts = function(_, opts)
    opts.filesystem.filtered_items = {
      hide_gitignored = false,
    }

    opts.window.mappings = vim.tbl_deep_extend("force", opts.window.mappings or {}, {
      ["l"] = "child_or_open",
      ["h"] = "close_node",
      ["\\"] = "open_vsplit",
      ["-"] = "open_split",
      ["s"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "s" } },
      ["sc"] = "order_by_created",
      ["sd"] = "order_by_diagnostics",
      ["sg"] = "order_by_git_status",
      ["sm"] = "order_by_modified",
      ["sn"] = "order_by_name",
      ["ss"] = "order_by_size",
      ["st"] = "order_by_type",
      ["o"] = "child_or_open",
      ["Y"] = "copy_selector",
      ["c"] = "add",
      ["oc"] = false,
      ["od"] = false,
      ["og"] = false,
      ["om"] = false,
      ["on"] = false,
      ["os"] = false,
      ["ot"] = false,
      ["S"] = false,
      ["C"] = false,
    })

    opts.event_handlers = vim.list_extend(opts.event_handlers or {}, {
      { event = "file_renamed", handler = function(data) Snacks.rename.on_rename_file(data.source, data.destination) end },
      { event = "file_moved", handler = function(data) Snacks.rename.on_rename_file(data.source, data.destination) end },
    })
  end,
}
