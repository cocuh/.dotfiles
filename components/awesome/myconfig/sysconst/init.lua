local hostname = (function()
  local f = io.popen("/bin/hostname")
  local hostname = f:read("*a") or ""
  f:close()
  hostname = string.gsub(hostname, "\n$", "")
  return hostname
end)()

local screen_num = 1
function initialize(screen)
  screen_num = screen.count()
end

return {
  initialize = initialize,
  screen_num = screen_num,
  hostname = hostname,
}
