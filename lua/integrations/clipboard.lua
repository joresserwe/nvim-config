-- Register a WSL2-only clipboard provider.
-- mac / native linux use nvim's default provider.
-- WSL2 clipboard: the executable check is slow, so defer it asynchronously.

local platform = require "core.platform"
if not platform.is_wsl then return end

vim.schedule(function()
  if platform.has_exec "win32yank.exe" then
    vim.g.clipboard = {
      name = "win32yank",
      copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf",
      },
      paste = {
        ["+"] = "win32yank.exe -o --lf",
        ["*"] = "win32yank.exe -o --lf",
      },
      cache_enabled = 0,
    }
  elseif platform.has_exec "clip.exe" and platform.has_exec "powershell.exe" then
    vim.g.clipboard = {
      name = "WslClipboard-fallback",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = { "powershell.exe", "-NoLogo", "-NoProfile", "-Command", "Get-Clipboard" },
        ["*"] = { "powershell.exe", "-NoLogo", "-NoProfile", "-Command", "Get-Clipboard" },
      },
      cache_enabled = 0,
    }
  end
  -- Neither available: fall back to the default provider (usually a no-op). No notify.
end)
