return {
  "lewis6991/gitsigns.nvim",
  enabled = vim.fn.executable "git" == 1,
  event = "User AstroGitFile",
  opts = function(_, opts)
    local sign = require("core.icons").get "GitSign"
    return vim.tbl_deep_extend("force", opts, {
      signs = {
        add = { text = sign },
        change = { text = sign },
        delete = { text = sign },
        topdelete = { text = sign },
        changedelete = { text = sign },
        untracked = { text = sign },
      },
      signs_staged = {
        add = { text = sign },
        change = { text = sign },
        delete = { text = sign },
        topdelete = { text = sign },
        changedelete = { text = sign },
        untracked = { text = sign },
      },
      on_attach = function(bufnr)
        local gs = require "gitsigns"
        local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

        map("n", "<Leader>gl", function() gs.blame_line() end, "View Git blame")
        map("n", "<Leader>gL", function() gs.blame_line { full = true } end, "View full Git blame")
        map("n", "<Leader>gp", function() gs.preview_hunk_inline() end, "Preview Git hunk")
        map("n", "<Leader>gr", function() gs.reset_hunk() end, "Reset Git hunk")
        map("v", "<Leader>gr", function() gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, "Reset Git hunk")
        map("n", "<Leader>gR", function() gs.reset_buffer() end, "Reset Git buffer")
        map("n", "<Leader>gs", function() gs.stage_hunk() end, "Stage/Unstage Git hunk")
        map("v", "<Leader>gs", function() gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, "Stage Git hunk")
        map("n", "<Leader>gS", function() gs.stage_buffer() end, "Stage Git buffer")
        map("n", "<Leader>gd", function() gs.diffthis() end, "View Git diff")

        map("n", "[G", function() gs.nav_hunk "first" end, "First Git hunk")
        map("n", "]G", function() gs.nav_hunk "last" end, "Last Git hunk")
        map("n", "]g", function() gs.nav_hunk "next" end, "Next Git hunk")
        map("n", "[g", function() gs.nav_hunk "prev" end, "Previous Git hunk")
        map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", "inside Git hunk")
      end,
    })
  end,
}
