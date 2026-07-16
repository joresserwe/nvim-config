-- Zed 스타일 LSP 심볼 네비게이터 (계층 유지, kind 필터링, 멀티셀렉트)
return {
  "bassamsdata/namu.nvim",
  event = "VeryLazy",
  keys = { { "<Leader>fs", "<cmd>Namu symbols<cr>", desc = "Search symbols (Namu)" } },
  opts = {
    namu_symbols = {
      options = {
        window = {
          width_ratio = 0.8,
          height_ratio = 0.8,
        },
      },
    },
  },
}
