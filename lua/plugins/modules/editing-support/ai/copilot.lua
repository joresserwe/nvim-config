-- Copilot ghost-text inline completion (log in with :Copilot auth; free tier available).
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    panel = { enabled = false },
    suggestion = {
      auto_trigger = true,
      hide_during_completion = false,
    },
  },
}
