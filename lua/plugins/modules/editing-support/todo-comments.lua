return {
  "folke/todo-comments.nvim",
  keys = {
    { "<Leader>ft", function() require("snacks").picker.todo_comments() end, desc = "Find todos" },
  },
}
