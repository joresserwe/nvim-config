return {
  "stevearc/conform.nvim",
  event = "User AstroFile",
  cmd = "ConformInfo",
  dependencies = { { "mason-org/mason.nvim", optional = true } },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = { start = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
      end
      require("conform").format { async = true, range = range }
    end, { desc = "Format buffer", range = true })
  end,
  keys = {
    {
      "<Leader>uf",
      function()
        vim.b.autoformat = not vim.F.if_nil(vim.b.autoformat, vim.g.autoformat, true)
        vim.notify(string.format("Buffer autoformatting %s", vim.b.autoformat and "on" or "off"))
      end,
      desc = "Toggle autoformatting (buffer)",
    },
    {
      "<Leader>uF",
      function()
        vim.g.autoformat, vim.b.autoformat = not vim.F.if_nil(vim.g.autoformat, true), nil
        vim.notify(string.format("Global autoformatting %s", vim.g.autoformat and "on" or "off"))
      end,
      desc = "Toggle autoformatting (global)",
    },
  },
  opts = {
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function(bufnr)
      if vim.F.if_nil(vim.b[bufnr].autoformat, vim.g.autoformat, true) then return { lsp_format = "fallback" } end
    end,
  },
}
