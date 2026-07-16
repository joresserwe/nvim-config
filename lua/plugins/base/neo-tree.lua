return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
    { "MunifTanjim/nui.nvim", lazy = true },
    { "s1n7ax/nvim-window-picker" },
  },
  cmd = "Neotree",
  opts_extend = { "sources", "event_handlers" },
  init = function()
    local group = vim.api.nvim_create_augroup("neotree_start", { clear = true })
    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      desc = "Open Neo-Tree on startup with directory",
      callback = function(args)
        if package.loaded["neo-tree"] then return true end
        local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
        if stats and stats.type == "directory" then
          require("lazy").load { plugins = { "neo-tree.nvim" } }
          pcall(vim.api.nvim_exec_autocmds, "BufEnter", { group = "NeoTree_NetrwDeferred", buffer = args.buf })
          return true
        end
      end,
    })
    vim.api.nvim_create_autocmd("TermClose", {
      group = vim.api.nvim_create_augroup("neotree_refresh", { clear = true }),
      pattern = "*lazygit*",
      desc = "Refresh Neo-Tree sources when closing lazygit",
      callback = function()
        local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
        if manager_avail then
          for _, source in ipairs { "filesystem", "git_status", "document_symbols" } do
            local module = "neo-tree.sources." .. source
            if package.loaded[module] then manager.refresh(require(module).name) end
          end
        end
      end,
    })
  end,
  opts = function(_, opts)
    local icons = require "core.icons"
    local git_available = vim.fn.executable "git" == 1
    local sources = {
      { source = "filesystem", display_name = icons.get("FolderClosed", 1) .. "File" },
      { source = "buffers", display_name = icons.get("DefaultFile", 1) .. "Bufs" },
      { source = "diagnostics", display_name = "\u{f04a1} Diagnostic" },
    }
    if git_available then
      table.insert(sources, 3, { source = "git_status", display_name = "\u{f02a2} Git" })
    end
    opts = vim.tbl_deep_extend("force", opts, {
      enable_git_status = git_available,
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      popup_border_style = "",
      sources = { "filesystem", "buffers", git_available and "git_status" or nil },
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = sources,
      },
      default_component_configs = {
        indent = {
          padding = 0,
          expander_collapsed = icons.get "FoldClosed",
          expander_expanded = icons.get "FoldOpened",
        },
        icon = {
          folder_closed = icons.get "FolderClosed",
          folder_open = icons.get "FolderOpen",
          folder_empty = icons.get "FolderEmpty",
          folder_empty_open = icons.get "FolderEmpty",
          default = icons.get "DefaultFile",
        },
        modified = { symbol = icons.get "FileModified" },
        git_status = {
          symbols = {
            added = icons.get "GitAdd",
            deleted = icons.get "GitDelete",
            modified = icons.get "GitChange",
            renamed = icons.get "GitRenamed",
            untracked = icons.get "GitUntracked",
            ignored = icons.get "GitIgnored",
            unstaged = icons.get "GitUnstaged",
            staged = icons.get "GitStaged",
            conflict = icons.get "GitConflict",
          },
        },
      },
      commands = {
        system_open = function(state) vim.ui.open(state.tree:get_node():get_id()) end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if node:has_children() and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node:has_children() then
            if not node:is_expanded() then
              state.commands.toggle_node(state)
            else
              if node.type == "file" then
                state.commands.open(state)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            end
          else
            state.commands.open(state)
          end
        end,
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["PATH"] = filepath,
            ["URI"] = vim.uri_from_fname(filepath),
          }

          local options = vim.tbl_filter(function(val) return vals[val] ~= "" end, vim.tbl_keys(vals))
          if vim.tbl_isempty(options) then
            vim.notify("No values to copy", vim.log.levels.WARN)
            return
          end
          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
          }, function(choice)
            local result = vals[choice]
            if result then
              vim.notify(("Copied: `%s`"):format(result))
              vim.fn.setreg("+", result)
            end
          end)
        end,
        find_files_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node.type == "file" and node:get_parent_id() or node:get_id()
          require("snacks").picker.files { cwd = path }
        end,
        find_all_files_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node.type == "file" and node:get_parent_id() or node:get_id()
          require("snacks").picker.files { cwd = path, hidden = true, ignored = true }
        end,
        find_words_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node.type == "file" and node:get_parent_id() or node:get_id()
          require("snacks").picker.grep { cwd = path }
        end,
        find_all_words_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node.type == "file" and node:get_parent_id() or node:get_id()
          require("snacks").picker.grep { cwd = path, hidden = true, ignored = true }
        end,
      },
      window = {
        width = 30,
        mappings = {
          ["<S-CR>"] = "system_open",
          ["<Space>"] = false,
          ["[b"] = "prev_source",
          ["]b"] = "next_source",
          O = "system_open",
          Y = "copy_selector",
          h = "parent_or_close",
          l = "child_or_open",
        },
        fuzzy_finder_mappings = {
          ["<C-J>"] = "move_cursor_down",
          ["<C-K>"] = "move_cursor_up",
        },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = { hide_gitignored = git_available },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = vim.fn.has "win32" ~= 1,
        window = {
          mappings = {
            f = { "show_help", nowait = false, config = { title = "Find Files", prefix_key = "f" } },
            ["f/"] = "filter_on_submit",
            ff = "find_files_in_dir",
            fF = "find_all_files_in_dir",
            fw = vim.fn.executable "rg" == 1 and "find_words_in_dir" or nil,
            fW = vim.fn.executable "rg" == 1 and "find_all_words_in_dir" or nil,
          },
        },
      },
    })

    if not opts.event_handlers then opts.event_handlers = {} end
    table.insert(opts.event_handlers, {
      event = "neo_tree_buffer_enter",
      handler = function(_)
        vim.opt_local.signcolumn = "auto"
        vim.opt_local.foldcolumn = "0"
      end,
    })
    return opts
  end,
}
