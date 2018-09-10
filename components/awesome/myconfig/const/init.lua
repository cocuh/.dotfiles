local hostname = require("myconfig.sysconst").hostname
local consts = {
    stern  = require("myconfig.const.stern"),
    shiina = require("myconfig.const.shiina"),
}

local const = consts[hostname]
if const == nil then
  const = require("myconfig.const.stern") -- default setting
end

return {
  get = function (key, default_value)
    if const[key] == nil then
      return default_value
    else
      return const[key]
    end
  end,
}
