-- Dim inactive windows.
---@type LazySpec
return {
  {
    "TaDaa/vimade",
    event = "VeryLazy",
    opts = {
      recipe = { "default", { animate = false } },
      fadelevel = 0.8,
      ncmode = "windows",
    },
  },
}