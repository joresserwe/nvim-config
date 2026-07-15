-- Copilot 고스트텍스트 인라인 완성 (:Copilot auth로 로그인, 무료 티어 가능)
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
