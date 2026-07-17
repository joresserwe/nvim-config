return {
  "folke/todo-comments.nvim",
  keys = {
    { "<Leader>fT", function() require("snacks").picker.todo_comments() end, desc = "Find todos" },
  },
}
