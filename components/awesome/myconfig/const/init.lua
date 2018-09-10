local hostname = (function()
  local f = io.popen("/bin/hostname")
  local hostname = f:read("*a") or ""
  f:close()
  hostname = string.gsub(hostname, "\n$", "")
  return hostname
end)()


local consts = {
    stern  = require("myconfig.const.stern"),
    shiina = require("myconfig.const.shiina"),
}

local const = consts[hostname]
if const == nil then
  const = require("myconfig.const.shiina") -- default setting
end

return {
  get = function (key, default_value)
    if const[key] == nil then
      return default_value
    else
      return const[key]
    end
  end,
  hostname = hostname,
}
