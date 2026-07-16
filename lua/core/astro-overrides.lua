-- AstroNvim 기본 매핑 무력화 전용. AstroNvim 제거 시 이 파일과 astrocore.lua의 소비 지점을 함께 삭제한다.
return function()
  local mappings = { n = {}, v = {}, x = {}, i = {}, t = {} }

  local function disable_keys(mode, keys)
    for _, key in ipairs(keys) do
      mappings[mode][key] = false
    end
  end

  mappings.n["|"] = false
  mappings.n["\\"] = false

  disable_keys("n", {
    "<Leader>C",
    -- Sessions (=> <Leader>s 로 이동)
    "<Leader>S", "<Leader>S.", "<Leader>Sd", "<Leader>SD",
    "<Leader>Sf", "<Leader>SF", "<Leader>Sl", "<Leader>Ss", "<Leader>SS", "<Leader>St",
    -- Debugger (=> <Leader>, 로 이동)
    "<Leader>db", "<Leader>dB", "<Leader>dc", "<Leader>dC", "<Leader>dE",
    "<Leader>dh", "<Leader>di", "<Leader>do", "<Leader>dO", "<Leader>dp",
    "<Leader>dq", "<Leader>dQ", "<Leader>dr", "<Leader>dR", "<Leader>ds", "<Leader>du",
    -- Finder (재할당 또는 미사용. fs는 namu.lua의 lazy keys가 대체)
    "<Leader>fb", "<Leader>fo", "<Leader>fO", "<Leader>fr", "<Leader>fs", "<Leader>ft", "<Leader>fw", "<Leader>fW",
    -- LSP
    "<Leader>lc", "<Leader>lD", "<Leader>lS", "<Leader>ls",
    -- Plugins (=> <Leader>' 로 이동)
    "<Leader>pa", "<Leader>pm", "<Leader>pM", "<Leader>pS", "<Leader>pu", "<Leader>pU",
    -- Terminal
    "<Leader>th", "<Leader>tl", "<Leader>tv",
    -- 기타
    "<Leader>h", "<Leader>lf", "<Leader>Mp", "<Leader>Ms", "<Leader>Mt",
    "<Leader>uA", "<Leader>xl", "<Leader>xq",
  })

  mappings.n["<Leader>'a"] = { function() require("astrocore").update_packages() end, desc = "Update Lazy and Mason" }

  return mappings
end
