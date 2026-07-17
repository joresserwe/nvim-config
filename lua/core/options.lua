local M = {}

M.options = {
  opt = {
    autoindent = true,
    relativenumber = true,
    number = true,
    smartindent = true,
    spell = false,
    signcolumn = "yes",
    wrap = false,
    sidescrolloff = 2, -- keep EOL text clear of the satellite scrollbar overlay
    winminwidth = 10, -- min width of other windows when one is maximized
    -- Korean 2-beolsik langmap: type Hangul in normal mode and it's read as the English keys
    langmap = table.concat({
      -- base rows (ㅂ=q ~ ㅔ=p, ㅁ=a ~ ㅣ=l, ㅋ=z ~ ㅡ=m)
      "ㅂq", "ㅈw", "ㄷe", "ㄱr", "ㅅt", "ㅛy", "ㅕu", "ㅑi", "ㅐo", "ㅔp",
      "ㅁa", "ㄴs", "ㅇd", "ㄹf", "ㅎg", "ㅗh", "ㅓj", "ㅏk", "ㅣl",
      "ㅋz", "ㅌx", "ㅊc", "ㅍv", "ㅠb", "ㅜn", "ㅡm",
      -- Shift (double consonants + ㅒㅖ)
      "ㅃQ", "ㅉW", "ㄸE", "ㄲR", "ㅆT", "ㅒO", "ㅖP",
    }, ","),
    langremap = false, -- keep langmap from affecting mapping RHS
  },
  g = {
    autoformat = false,
  },
}

return M
