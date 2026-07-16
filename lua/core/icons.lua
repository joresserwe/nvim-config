local M = {}

M.icons = {
  ActiveLSP = "\u{f085}",
  Bookmarks = "\u{f02e}",
  DapBreakpoint = "\u{f192}",
  DapBreakpointCondition = "\u{f059}",
  DapBreakpointRejected = "\u{f06a}",
  DapLogPoint = "\u{f06ff}",
  DapPaused = "\u{f03e4}",
  DapStopped = "\u{f0055}",
  Debugger = "\u{f188}",
  DefaultFile = "\u{f0219}",
  DiagnosticError = "\u{f057}",
  DiagnosticHint = "\u{f0335}",
  DiagnosticInfo = "\u{f02fc}",
  DiagnosticWarn = "\u{f071}",
  FileModified = "\u{f444}",
  FileNew = "\u{f0fe}",
  FoldClosed = "\u{f460}",
  FoldOpened = "\u{f47c}",
  FoldSeparator = " ",
  FolderClosed = "\u{e5ff}",
  FolderEmpty = "\u{f414}",
  FolderOpen = "\u{e5fe}",
  GitAdd = "\u{f0fe}",
  GitBranch = "\u{e725}",
  GitChange = "\u{f14b}",
  GitConflict = "\u{e727}",
  GitDelete = "\u{f146}",
  GitIgnored = "\u{25cc}",
  GitRenamed = "\u{279c}",
  Git = "\u{f02a2}",
  GitSign = "\u{258e}",
  GitStaged = "\u{2713}",
  GitUnstaged = "\u{2717}",
  GitUntracked = "\u{2605}",
  LSPLoading1 = "\u{280b}",
  LSPLoading2 = "\u{2819}",
  LSPLoading3 = "\u{2839}",
  LSPLoading4 = "\u{2838}",
  LSPLoading5 = "\u{283c}",
  LSPLoading6 = "\u{2834}",
  LSPLoading7 = "\u{2826}",
  LSPLoading8 = "\u{2827}",
  LSPLoading9 = "\u{2807}",
  LSPLoading10 = "\u{280f}",
  Markdown = "\u{e73e}",
  Paste = "\u{f014c}",
  Refactoring = "\u{f08ea}",
  Refresh = "\u{f01e}",
  Search = "\u{f422}",
  Session = "\u{f10ac}",
  Sort = "\u{f04ba}",
  Tab = "\u{f04e9}",
  Terminal = "\u{e795}",
  Window = "\u{eb7f}",
  WordFile = "\u{f022d}",
}

---@param name string icon key in M.icons
---@param padding? integer trailing spaces to append
---@return string
function M.get(name, padding)
  local icon = M.icons[name]
  return icon and icon .. (" "):rep(padding or 0) or ""
end

return M
