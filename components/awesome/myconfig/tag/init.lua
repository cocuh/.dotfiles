local hostname = require("myconfig.const").hostname
local tags = {}

local tag = tags[hostname]
if tag == nil then
  tag = require("myconfig.tag.default")
end

return {
  get_tag_names = tag.get_tag_names,
}
