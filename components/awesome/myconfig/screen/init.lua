local hostname = require("myconfig.sysconst").hostname 


local screens = {
  shiina = require("myconfig.screen.shiina")
}

local screen = screens[hostname]
if screen == nil then
  screen = require("myconfig.screen.stern") -- default setting
end

return {
  get_screen_ids = screen.get_screen_ids,
  get_primary_screen_id = screen.get_primary_screen_id,
}
