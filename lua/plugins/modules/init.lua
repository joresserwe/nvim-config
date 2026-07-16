local M = {}

local exclude = {
  "editing-support.ai.claude-pane",
}

-- Normalize paths for cross-platform compatibility
local function normalize_path(path) return path:gsub("\\", "/"):gsub("//+", "/") end

-- Get the base module name dynamically based on the directory structure
local function get_base_module(current_dir)
  local config_dir = vim.fn.stdpath "config" -- ~/.config/nvim
  local lua_root = normalize_path(config_dir .. "/lua/")
  current_dir = normalize_path(current_dir)

  -- Extract the relative path after "lua/" and convert it to dot notation
  local relative_path = current_dir:gsub("^" .. lua_root, "")
  return relative_path:gsub("/", "."):gsub("^%.", "")
end

-- Function to check if a module should be excluded
local function should_exclude(module_name)
  for _, pattern in ipairs(exclude) do
    if module_name == pattern or module_name:sub(1, #pattern) == pattern then return true end
  end
  return false
end

-- Collect directories that have their own init.lua — their child files are managed by that init.lua.
local function collect_init_dirs(modules, dir)
  local init_dirs = {}
  for _, path in ipairs(modules) do
    local normalized = normalize_path(path)
    if normalized:match "/init%.lua$" and normalized ~= normalize_path(dir .. "/init.lua") then
      local init_dir = normalized:gsub("/init%.lua$", "")
      init_dirs[init_dir] = true
    end
  end
  return init_dirs
end

-- Whether path is a child file inside one of init_dirs.
local function is_child_of_init_dir(path, init_dirs)
  for init_dir in pairs(init_dirs) do
    if path ~= init_dir .. "/init.lua" and path:sub(1, #init_dir + 1) == init_dir .. "/" then return true end
  end
  return false
end

-- Load all Lua files recursively from a given directory
local function load_modules(dir)
  dir = normalize_path(dir)
  local modules = vim.fn.globpath(dir, "**/*.lua", true, true) -- Find all Lua files recursively
  local base_module = get_base_module(dir) -- Dynamically determine the base module name
  local init_dirs = collect_init_dirs(modules, dir)

  for _, path in ipairs(modules) do
    local normalized = normalize_path(path)
    local module_name = normalized:gsub("^" .. dir:gsub("%.", "%%%.") .. "/?", ""):gsub("/", "."):gsub("%.lua$", "")

    -- Skip: root init.lua, excluded modules, child files of directories with their own init.lua
    if module_name ~= "init" and not should_exclude(module_name) and not is_child_of_init_dir(normalized, init_dirs) then
      local full_module = base_module .. "." .. module_name
      local ok, result = pcall(require, full_module)
      if ok then
        if type(result) == "table" then
          if vim.islist(result) then
            vim.list_extend(M, result)
          else
            table.insert(M, result)
          end
        end
      else
        vim.notify(("Failed to load module: %s\nReason: %s"):format(full_module, result), vim.log.levels.ERROR)
      end
    end
  end
end

-- Get the current script path (cross-platform compatibility)
local script_path = normalize_path(debug.getinfo(1, "S").source:sub(2))
local current_dir = vim.fn.fnamemodify(script_path, ":h")

load_modules(current_dir)

return M
