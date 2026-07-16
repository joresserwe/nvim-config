return {
  {
    "gbprod/yanky.nvim",
    dependencies = {
      { "folke/snacks.nvim" },
    },
    opts = {
      highlight = { timer = 200 },
      ring = { storage = "shada" },
    },
    keys = {
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank (yanky)" },
      { "<Leader>fy", function() require("snacks").picker.yanky() end, mode = { "n", "x" }, desc = "Find yanks" },
      { "sy", function() require("snacks").picker.yanky() end, mode = { "n", "x" }, desc = "Find yanks" },
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          yanky = {
            layout = {
              layout = {
                box = "vertical",
                width = 0.7,
                height = 0.8,
                border = "rounded",
                { win = "input", height = 1, border = "bottom", title = "Filter", title_pos = "center" },
                { win = "list", border = "rounded", title = "Yank", title_pos = "center" },
                { win = "preview", height = 0.4, border = "none" },
              },
            },
            formatters = { severity = { level = true } },
            focus = "list",
            actions = {
              delete_yank_history = function(picker, item)
                local selected_items = picker:selected()

                local item_list = nil
                if selected_items == nil or (type(selected_items) == "table" and vim.tbl_isempty(selected_items)) then
                  if item then
                    item_list = { item }
                  else
                    item_list = nil
                  end
                else
                  item_list = type(selected_items) == "table" and selected_items or { selected_items }
                end

                if not item_list then
                  vim.notify("Could not retrieve selected item(s) to delete", vim.log.levels.ERROR)
                  return
                end

                local indices_to_delete = {}
                local items_without_id_count = 0
                for _, selected_item in ipairs(item_list) do
                  local yanky_identifier = selected_item and selected_item.idx
                  if yanky_identifier then
                    local found = false
                    for _, existing_idx in ipairs(indices_to_delete) do
                      if existing_idx == yanky_identifier then
                        found = true
                        break
                      end
                    end
                    if not found then table.insert(indices_to_delete, yanky_identifier) end
                  else
                    items_without_id_count = items_without_id_count + 1
                    vim.notify(
                      "Could not get identifier from selected item: " .. vim.inspect(selected_item),
                      vim.log.levels.WARN
                    )
                  end
                end

                if #indices_to_delete == 0 then
                  if items_without_id_count == 0 then
                    vim.notify("No valid yank entries found to delete.", vim.log.levels.INFO)
                  end
                  return
                end

                table.sort(indices_to_delete, function(a, b) return a > b end)

                local deleted_count = 0
                local failed_count = items_without_id_count -- seed the failure count with items that have no id

                for _, index_to_delete in ipairs(indices_to_delete) do
                  local success, err = pcall(require("yanky.picker").actions.delete(), {
                    history_index = index_to_delete,
                  })
                  if success then
                    deleted_count = deleted_count + 1
                  else
                    failed_count = failed_count + 1
                    vim.notify(
                      "Failed to delete yank entry (ID: " .. tostring(index_to_delete) .. "): " .. tostring(err),
                      vim.log.levels.WARN
                    )
                  end
                end

                local final_msg = {}
                if deleted_count > 0 then
                  table.insert(
                    final_msg,
                    "Deleted " .. deleted_count .. " yank entr" .. (deleted_count > 1 and "ies" or "y") .. "."
                  )
                end
                if failed_count > 0 then
                  table.insert(
                    final_msg,
                    "Failed to delete " .. failed_count .. " entr" .. (failed_count > 1 and "ies" or "y") .. "."
                  )
                end
                if #final_msg > 0 then vim.notify(table.concat(final_msg, " "), vim.log.levels.INFO) end

                -- Refresh the picker if anything was deleted (close and reopen).
                if deleted_count > 0 then
                  picker:close()
                  vim.schedule(function() require("snacks").picker.yanky() end)
                end
              end,
            },
            win = {
              input = {
                keys = {
                  ["<c-d>"] = { "delete_yank_history", mode = { "i", "n" } },
                },
              },
              list = {
                keys = {
                  ["<c-d>"] = "delete_yank_history",
                },
              },
            },
          },
        },
      },
    },
  },
}
