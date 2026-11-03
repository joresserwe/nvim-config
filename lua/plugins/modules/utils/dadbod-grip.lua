local Kind = vim.lsp.protocol.CompletionItemKind
local grip_data = vim.fn.stdpath "data" .. "/grip"

local function statement_at(bufnr, row)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local function boundary(line) return line:match "^%s*$" or line:match "^%s*```" end
  local first, last = row, row
  while first > 1 and not boundary(lines[first - 1]) and not lines[first - 1]:find ";%s*$" do
    first = first - 1
  end
  while last < #lines and not boundary(lines[last + 1]) and not lines[last]:find ";%s*$" do
    last = last + 1
  end
  return table.concat(lines, "\n", first, last):lower()
end

local function column_owners(url, sql)
  local refs = {}
  for _, kw in ipairs { "from", "join" } do
    for name in sql:gmatch("%f[%w]" .. kw .. "%s+([%w_%.\"]+)") do
      refs[name:gsub('"', ""):match "[^.]+$"] = true
    end
  end
  local owners, in_scope, any_scoped = {}, {}, false
  local schema = require("dadbod-grip.completion").get_schema(url)
  local names = vim.tbl_keys(schema)
  table.sort(names)
  for _, tbl in ipairs(names) do
    local scoped = refs[tbl:lower():match "[^.]+$"]
    any_scoped = any_scoped or scoped == true
    for _, col in ipairs(schema[tbl]) do
      local cname = col.column_name
      if cname and (not owners[cname] or (scoped and not in_scope[cname])) then
        owners[cname], in_scope[cname] = tbl, scoped or nil
      end
    end
  end
  return owners, any_scoped and in_scope or nil
end

return {
  {
    "joryeugene/dadbod-grip.nvim",
    -- Don't use version = "*": the author reset tags from v3.x back to v1.x,
    -- so semver "*" pins to the pre-fix v3.3.1 and throws a lazy.lua spec error.
    opts = { completion = false, connections_path = grip_data .. "/connections.json" },
    config = function(_, opts)
      require("dadbod-grip.paths").grip_dir = function() return grip_data end
      require("dadbod-grip").setup(opts)
      require("i18n.dadbod-grip").apply()
    end,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        per_filetype = { sql = { inherit_defaults = true, "dadbod_grip" } },
        providers = {
          dadbod_grip = {
            name = "Grip SQL",
            module = "dadbod-grip.completion.blink",
            transform_items = function(ctx, items)
              local owners, in_scope
              local kept = {}
              for _, item in ipairs(items) do
                local detail = (item.detail or ""):gsub("[%[%]]", "")
                local keep = true
                if item.kind == Kind.Field then
                  if not owners then
                    owners, in_scope = column_owners(vim.b[ctx.bufnr].db or vim.g.db, statement_at(ctx.bufnr, ctx.cursor[1]))
                  end
                  local owner = owners[item.label]
                  detail = owner and (owner .. " · " .. detail) or detail
                  if in_scope then
                    keep = in_scope[item.label] ~= nil
                    item.score_offset = 20
                  end
                elseif item.kind == Kind.Keyword then
                  item.filterText = item.label:lower()
                end
                if keep then
                  item.labelDetails = { description = detail }
                  kept[#kept + 1] = item
                end
              end
              return kept
            end,
          },
          buffer = { enabled = function() return vim.b.db == nil end },
        },
      },
    },
  },
}
