local M = {}

local default_ports = { postgres = "5432", postgresql = "5432", mysql = "3306", mariadb = "3306", sqlserver = "1433" }

local function decode(value)
  return value and value:gsub("%%(%x%x)", function(hex) return string.char(tonumber(hex, 16)) end)
end

local function connection_lines(url, name)
  local scheme, rest = url:match "^([%w+.-]+)://(.*)$"
  scheme = scheme or url:match "^([%w+.-]+):"
  local lines = { "연결: " .. (name or "이름 없음"), "종류: " .. (scheme or "알 수 없음") }
  if scheme == "sqlite" or scheme == "duckdb" then
    lines[#lines + 1] = "파일: " .. (rest or url:sub(#scheme + 2)):gsub("[?#].*$", "")
  elseif rest then
    local base, query = rest:match "^([^?]*)%??(.*)$"
    local authority, database = base:match "^([^/]*)(.*)$"
    local auth, hostport = authority:match "^(.*)@([^@]*)$"
    hostport = hostport or authority
    local user = auth and auth:match "^([^:]*)"
    local host, port = hostport:match "^%[([^%]]+)%]:?(%d*)$"
    if not host then
      host, port = hostport:match "^([^:]*):(%d+)$"
    end
    host = host or hostport
    database = decode(database:gsub("^/", ""))
    user, host = decode(user), decode(host)
    if scheme == "postgres" or scheme == "postgresql" then
      for key, value in query:gmatch "([^&=]+)=([^&]*)" do
        value = decode(value)
        if key == "host" then host = value end
        if key == "port" then port = value end
        if key == "dbname" then database = value end
        if key == "user" then user = value end
      end
    end
    local has_port = port and port ~= ""
    lines[#lines + 1] = "주소: " .. (host ~= "" and host or "미지정 (클라이언트 기본값)")
    lines[#lines + 1] = "포트: "
      .. (has_port and port or default_ports[scheme] and (default_ports[scheme] .. " (기본값)") or "미지정")
    lines[#lines + 1] = "DB: " .. (database ~= "" and database or "미지정")
    lines[#lines + 1] = "사용자: " .. (user and user ~= "" and user or "미지정")
  else
    lines[#lines + 1] = "이 연결 형식은 주소·포트 표시를 지원하지 않습니다."
  end
  return lines
end

function M.show()
  local connections = require "dadbod-grip.connections"
  local current = connections.current()
  local url = vim.b.db or (current and current.url)
  if type(url) ~= "string" or url == "" then
    vim.notify("현재 DB 연결이 없습니다.", vim.log.levels.INFO)
    return
  end
  local expanded = connections.expand_url(url)
  if not expanded then
    vim.notify("접속 정보의 환경변수를 해석하지 못했습니다.", vim.log.levels.WARN)
    return
  end
  local entry = connections.entry_for(url)
  local name = entry and entry.name or (current and current.url == url and current.name or nil)
  local lines = connection_lines(expanded, name)
  lines[#lines + 1] = ""
  lines[#lines + 1] = "q / Esc: 닫기"
  local buf, win = vim.lsp.util.open_floating_preview(lines, "text", {
    border = "rounded",
    title = " DB 접속 정보 ",
    focus_id = "grip_connection_info",
    max_width = math.max(1, math.min(88, vim.o.columns - 4)),
    max_height = math.max(1, vim.o.lines - 6),
    wrap = true,
  })
  vim.api.nvim_set_current_win(win)
  vim.bo[buf].modifiable = false
  for _, key in ipairs { "q", "<Esc>" } do
    vim.keymap.set("n", key, function()
      if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    end, { buffer = buf, silent = true, desc = "접속 정보 닫기" })
  end
end

return M
