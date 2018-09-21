local hostname = require("myconfig.sysconst").hostname
local tags = {
  shiina = require("myconfig.tag.shiina"),
}

local tag = tags[hostname]
if tag == nil then
  tag = require("myconfig.tag.default")
end

return {
  get_tag_names = tag.get_tag_names,
}
