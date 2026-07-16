-- Project-wide search/replace (ripgrep-based).
return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    { "<Leader>fr", function() require("grug-far").open() end, desc = "Find and Replace (GrugFar)" },
  },
  opts = {},
}
