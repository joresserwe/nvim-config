local platform = require "core.platform"

local backends = {
  { name = "wezterm", active = platform.in_wezterm },
  -- kitty: add { name = "kitty", active = ... } backed by integrations/term/kitty.lua
}

for _, backend in ipairs(backends) do
  if backend.active then
    require("integrations.term." .. backend.name)
    break
  end
end
