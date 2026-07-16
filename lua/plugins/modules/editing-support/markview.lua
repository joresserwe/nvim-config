-- Work around a markview.nvim error: when strict_render is called from the snacks picker
-- preview, preview.callbacks becomes nil and throws.
---@type LazySpec
return {
  "OXY2DEV/markview.nvim",
  opts = {
    preview = {
      callbacks = {
        on_attach = function(_, wins)
          for _, win in ipairs(wins or {}) do
            vim.wo[win].conceallevel = 3
          end
        end,
      },
    },
  },
}
