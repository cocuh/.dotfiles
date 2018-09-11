local gears = require("gears")
local sysconst = require("myconfig.sysconst")

local hostname = require("myconfig.sysconst").hostname
local home_dir = os.getenv("HOME")


local wallpapers = {
  stern = {
    default = home_dir .. "/picture/wallpaper/materials.png",
  },
  shiina = {
    default = home_dir .. "/picture/wallpaper/stella.png",
  },
}

local wallpaper_setting = wallpapers[hostname]

function set_wallpaper(path)
  for s=1, sysconst.screen_num do
    gears.wallpaper.maximized(path, s)
  end
end

function set_default_wallpaper()
  if wallpaper_setting ~= nil then
    set_wallpaper(wallpaper_setting.default)
  end
end

return {
  set_wallpaper = set_wallpaper,
  set_default_wallpaper = set_default_wallpaper,
}
