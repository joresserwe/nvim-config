-- Dim inactive windows.
---@type LazySpec
return {
  {
    "TaDaa/vimade",
    event = "VeryLazy",
    opts = {
      recipe = { "default", { animate = true } },
      fadelevel = 0.8,
      ncmode = "windows",
    },
  },
}