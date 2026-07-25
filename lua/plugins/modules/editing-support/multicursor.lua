return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  keys = {
    { "mm", function() require("multicursor-nvim").matchAddCursor(1) end, mode = { "n", "x" }, desc = "다음 매치에 커서 추가" },
    { "mM", function() require("multicursor-nvim").matchAddCursor(-1) end, mode = { "n", "x" }, desc = "이전 매치에 커서 추가" },
    { "m*", function() require("multicursor-nvim").matchAllAddCursors() end, mode = { "n", "x" }, desc = "모든 매치에 커서 추가" },
    { "m/", function() require("multicursor-nvim").searchAllAddCursors() end, desc = "검색 결과 전체에 커서 추가" },
    { "mj", function() require("multicursor-nvim").lineAddCursor(1) end, mode = { "n", "x" }, desc = "아래줄에 커서 추가" },
    { "mk", function() require("multicursor-nvim").lineAddCursor(-1) end, mode = { "n", "x" }, desc = "윗줄에 커서 추가" },
  },
  config = function()
    local mc = require "multicursor-nvim"
    mc.setup()
    mc.addKeymapLayer(function(layerSet)
      layerSet({ "n", "x" }, "<Esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end)
    end)
  end,
}
