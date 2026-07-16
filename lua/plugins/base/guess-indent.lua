return {
  "NMAC427/guess-indent.nvim",
  cmd = "GuessIndent",
  opts = { auto_cmd = false },
  init = function()
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = vim.api.nvim_create_augroup("base_guess_indent", { clear = true }),
      desc = "Guess indentation when loading a file",
      callback = function(args) require("guess-indent").set_from_buffer(args.buf, true, true) end,
    })
    vim.api.nvim_create_autocmd("BufNewFile", {
      group = "base_guess_indent",
      desc = "Guess indentation when saving a new file",
      callback = function(args)
        vim.api.nvim_create_autocmd("BufWritePost", {
          buffer = args.buf,
          once = true,
          callback = function(wargs) require("guess-indent").set_from_buffer(wargs.buf, true, true) end,
        })
      end,
    })
  end,
}
